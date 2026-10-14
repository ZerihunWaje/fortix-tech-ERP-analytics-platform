-- grain: one row per product line on a sale per tenant
-- excludes lines of soft-deleted sales
-- est_* columns use the product's CURRENT cost: the ERP does not store cost at time of sale
with lines as (
    select * from {{ ref('stg_erp__sale_details') }}
),

sales as (
    select * from {{ ref('stg_erp__sales') }}
    where not is_deleted
),

products as (
    select product_key, unit_cost from {{ ref('stg_erp__products') }}
)

select
    l.sale_line_key,
    l.sale_key,
    s.tenant_id,
    s.sale_date,
    s.client_key,
    s.warehouse_key,
    l.product_key,
    s.sale_status,
    s.sale_status = 'completed'                     as is_completed,
    l.quantity,
    l.unit_price,
    l.discount,
    l.line_total,
    p.unit_cost                                     as est_unit_cost,
    round(l.quantity * p.unit_cost, 2)              as est_cost,
    round(l.line_total - l.quantity * p.unit_cost, 2) as est_gross_margin
from lines as l
inner join sales as s
    on s.sale_key = l.sale_key
left join products as p
    on p.product_key = l.product_key
