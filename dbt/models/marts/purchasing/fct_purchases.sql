-- grain: one row per purchase per tenant; soft-deleted purchases excluded
with purchases as (
    select * from {{ ref('stg_erp__purchases') }}
    where not is_deleted
),

lines as (
    select
        purchase_key,
        count(*)         as line_count,
        sum(quantity)    as units_purchased,
        sum(line_total)  as lines_total
    from {{ ref('stg_erp__purchase_details') }}
    group by purchase_key
)

select
    p.purchase_key,
    p.tenant_id,
    p.purchase_ref,
    p.purchase_date,
    p.supplier_key,
    p.warehouse_key,
    p.purchase_status,
    p.purchase_status = 'received'              as is_received,
    p.payment_status,
    coalesce(l.line_count, 0)                   as line_count,
    coalesce(l.units_purchased, 0)              as units_purchased,
    coalesce(l.lines_total, 0)                  as lines_total,
    p.discount_amount,
    p.tax_amount,
    p.shipping_amount,
    p.grand_total,
    p.paid_amount,
    p.amount_due,
    p.purchase_date > coalesce(p.created_at::date, current_date) as is_future_dated,
    p.created_at
from purchases as p
left join lines as l
    on l.purchase_key = p.purchase_key
