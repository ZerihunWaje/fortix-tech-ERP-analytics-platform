-- grain: one row per product per tenant (deleted products kept and flagged,
-- because older sale lines can still point to them)
with products as (
    select * from {{ ref('stg_erp__products') }}
),

categories as (
    select * from {{ ref('stg_erp__categories') }}
),

brands as (
    select * from {{ ref('stg_erp__brands') }}
),

units as (
    select * from {{ ref('stg_erp__units') }}
)

select
    p.product_key,
    p.tenant_id,
    p.product_code,
    p.product_name,
    coalesce(c.category_name, 'Uncategorised')  as category_name,
    coalesce(b.brand_name, 'No brand')          as brand_name,
    u.unit_short_name                           as unit,
    p.product_type,
    p.unit_cost                                 as current_unit_cost,
    p.unit_price                                as current_unit_price,
    case when p.unit_price > 0
         then round((p.unit_price - p.unit_cost) / p.unit_price, 4) end as current_margin_pct,
    p.stock_alert_qty,
    p.is_active,
    p.is_not_selling,
    p.is_deleted
from products as p
left join categories as c on c.category_key = p.category_key
left join brands     as b on b.brand_key    = p.brand_key
left join units      as u on u.unit_key     = p.unit_key
