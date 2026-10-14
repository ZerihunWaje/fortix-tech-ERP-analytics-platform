-- grain: one row per sale (invoice) per tenant
-- excludes soft-deleted sales; revenue measures should filter is_completed = true
with sales as (
    select * from {{ ref('stg_erp__sales') }}
    where not is_deleted
),

lines as (
    select
        sale_key,
        count(*)          as line_count,
        sum(quantity)     as units_sold,
        sum(line_total)   as lines_total
    from {{ ref('stg_erp__sale_details') }}
    group by sale_key
)

select
    s.sale_key,
    s.tenant_id,
    s.sale_ref,
    s.sale_date,
    s.client_key,
    s.warehouse_key,
    s.sale_status,
    s.sale_status = 'completed'                     as is_completed,
    s.payment_status,
    s.is_pos,
    coalesce(l.line_count, 0)                       as line_count,
    coalesce(l.units_sold, 0)                       as units_sold,
    coalesce(l.lines_total, 0)                      as lines_total,
    s.discount_amount,
    s.tax_amount,
    s.shipping_amount,
    s.grand_total,
    -- what the invoice total differs from its lines by (sale-level discount, tax, shipping)
    s.grand_total - coalesce(l.lines_total, 0)      as header_adjustment,
    s.paid_amount,
    s.amount_due,
    -- dated later than the day it was entered into the ERP (post-dated / typo)
    s.sale_date > coalesce(s.created_at::date, current_date) as is_future_dated,
    s.created_at
from sales as s
left join lines as l
    on l.sale_key = s.sale_key
