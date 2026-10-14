-- grain: one row per product line on a purchase per tenant; lines of deleted purchases excluded
with lines as (
    select * from {{ ref('stg_erp__purchase_details') }}
),

purchases as (
    select * from {{ ref('stg_erp__purchases') }}
    where not is_deleted
)

select
    l.purchase_line_key,
    l.purchase_key,
    p.tenant_id,
    p.purchase_date,
    p.supplier_key,
    p.warehouse_key,
    l.product_key,
    p.purchase_status,
    l.quantity,
    l.unit_cost,
    l.discount,
    l.line_total
from lines as l
inner join purchases as p
    on p.purchase_key = l.purchase_key
