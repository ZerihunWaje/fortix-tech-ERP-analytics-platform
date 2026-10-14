-- grain: one row per supplier per tenant (no personal data, ADR 0003)
select
    supplier_key,
    tenant_id,
    supplier_label,
    city,
    country,
    is_deleted
from {{ ref('stg_erp__providers') }}
