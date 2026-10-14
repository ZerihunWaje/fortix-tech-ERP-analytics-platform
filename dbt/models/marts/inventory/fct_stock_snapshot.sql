-- grain: one row per product (variant) per warehouse per tenant, as of the last ingestion
-- excludes deleted stock rows, deleted products and deleted warehouses
with stock as (
    select * from {{ ref('stg_erp__product_warehouse') }}
    where not is_deleted
),

products as (
    select * from {{ ref('stg_erp__products') }}
    where not is_deleted
),

warehouses as (
    select * from {{ ref('stg_erp__warehouses') }}
    where not is_deleted
),

load_date as (
    select max(cast(_loaded_at as timestamptz))::date as snapshot_date
    from {{ source('erp', 'product_warehouse') }}
),

joined as (
    select
        st.product_warehouse_key,
        st.tenant_id,
        st.product_key,
        st.warehouse_key,
        ld.snapshot_date,
        st.quantity_on_hand,
        p.unit_cost,
        p.unit_price,
        round(st.quantity_on_hand * p.unit_cost, 2)  as stock_value_cost,
        round(st.quantity_on_hand * p.unit_price, 2) as stock_value_retail,
        p.stock_alert_qty,
        sum(st.quantity_on_hand) over (partition by st.product_key) as product_total_on_hand
    from stock as st
    inner join products   as p on p.product_key   = st.product_key
    inner join warehouses as w on w.warehouse_key = st.warehouse_key
    cross join load_date  as ld
)

select
    *,
    product_total_on_hand <= coalesce(stock_alert_qty, 0) as is_product_below_alert,
    quantity_on_hand < 0                                  as is_negative
from joined
