-- grain: one row per tenant per data-quality check
-- Feeds the Power BI "Data quality" page. Every tenant gets every check (0 issues when clean).

with tenants as (
    select tenant_id from {{ ref('dim_tenant') }}
),

check_definitions as (
    select * from (values
        ('deleted_products',           'Completeness', 'Products soft-deleted in the ERP',                         0.05, 0.25),
        ('deleted_sales',              'Completeness', 'Sales soft-deleted in the ERP',                            0.05, 0.25),
        ('deleted_purchases',          'Completeness', 'Purchases soft-deleted in the ERP',                        0.05, 0.25),
        ('future_dated_sales',         'Validity',     'Sales dated later than the day they were entered',          0.00, 0.01),
        ('future_dated_purchases',     'Validity',     'Purchases dated later than the day they were entered',      0.00, 0.01),
        ('currency_setting_mismatch',  'Validity',     'ERP currency setting differs from the reporting currency',  0.00, 0.00),
        ('sales_without_lines',        'Consistency',  'Sales with no product lines',                               0.00, 0.05),
        ('sale_lines_unknown_product', 'Consistency',  'Sale lines pointing to a product that does not exist',      0.00, 0.01),
        ('negative_stock_rows',        'Validity',     'Stock rows with negative quantity on hand',                 0.00, 0.01),
        ('products_below_stock_alert', 'Operations',   'Active products at or below their stock alert level',       0.20, 0.50)
    ) as t(check_name, category, check_description, warn_above, problem_above)
),

results as (

    select tenant_id, 'deleted_products' as check_name,
           count(*) filter (where is_deleted) as issues, count(*) as rows_checked
    from {{ ref('stg_erp__products') }} group by 1

    union all
    select tenant_id, 'deleted_sales',
           count(*) filter (where is_deleted), count(*)
    from {{ ref('stg_erp__sales') }} group by 1

    union all
    select tenant_id, 'deleted_purchases',
           count(*) filter (where is_deleted), count(*)
    from {{ ref('stg_erp__purchases') }} group by 1

    union all
    select tenant_id, 'future_dated_sales',
           count(*) filter (where is_future_dated), count(*)
    from {{ ref('fct_sales') }} group by 1

    union all
    select tenant_id, 'future_dated_purchases',
           count(*) filter (where is_future_dated), count(*)
    from {{ ref('fct_purchases') }} group by 1

    union all
    select tenant_id, 'currency_setting_mismatch',
           case when has_currency_mismatch then 1 else 0 end, 1
    from {{ ref('dim_tenant') }}

    union all
    select tenant_id, 'sales_without_lines',
           count(*) filter (where line_count = 0), count(*)
    from {{ ref('fct_sales') }} group by 1

    union all
    select l.tenant_id, 'sale_lines_unknown_product',
           count(*) filter (where p.product_key is null), count(*)
    from {{ ref('fct_sales_lines') }} as l
    left join {{ ref('dim_product') }} as p on p.product_key = l.product_key
    group by 1

    union all
    select tenant_id, 'negative_stock_rows',
           count(*) filter (where is_negative), count(*)
    from {{ ref('fct_stock_snapshot') }} group by 1

    union all
    select tenant_id, 'products_below_stock_alert',
           count(distinct product_key) filter (where is_product_below_alert),
           count(distinct product_key)
    from {{ ref('fct_stock_snapshot') }} group by 1
),

final as (
    select
        t.tenant_id,
        d.check_name,
        d.category,
        d.check_description,
        coalesce(r.issues, 0)        as issues,
        coalesce(r.rows_checked, 0)  as rows_checked,
        case when coalesce(r.rows_checked, 0) > 0
             then round(r.issues::numeric / r.rows_checked, 4) else 0 end as issue_rate,
        d.warn_above,
        d.problem_above
    from tenants as t
    cross join check_definitions as d
    left join results as r
        on r.tenant_id = t.tenant_id and r.check_name = d.check_name
)

select
    tenant_id || '|' || check_name as dq_check_key,
    *,
    case
        when rows_checked = 0            then 'Not applicable'
        when issue_rate > problem_above  then 'Problem'
        when issue_rate > warn_above     then 'Warning'
        else 'OK'
    end as status
from final
