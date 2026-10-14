-- Warn about sales dated later than the day they were entered (seen in the source data).
{{ config(severity='warn') }}

select tenant_id, sale_key, sale_date, created_at
from {{ ref('fct_sales') }}
where is_future_dated
