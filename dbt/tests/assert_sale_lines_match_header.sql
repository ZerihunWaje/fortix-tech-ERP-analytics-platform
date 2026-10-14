-- Warn when a completed sale's total differs from its lines by more than its own
-- sale-level discount, tax and shipping can explain (tolerance 1 ETB).
{{ config(severity='warn') }}

select tenant_id, sale_key, grand_total, lines_total, discount_amount, tax_amount, shipping_amount
from {{ ref('fct_sales') }}
where is_completed
  and line_count > 0
  and abs(grand_total - (lines_total - discount_amount + tax_amount + shipping_amount)) > 1
