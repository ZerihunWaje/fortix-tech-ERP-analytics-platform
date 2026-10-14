-- Warn when any product shows negative stock in a warehouse (sold more than was recorded as received).
{{ config(severity='warn') }}

select tenant_id, product_key, warehouse_key, quantity_on_hand
from {{ ref('fct_stock_snapshot') }}
where quantity_on_hand < 0
