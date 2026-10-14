-- grain: one row per client per tenant (no personal data, ADR 0003)
select
    client_key,
    tenant_id,
    client_label,
    is_walk_in_customer,
    city,
    country,
    created_at::date as client_since,
    is_deleted
from {{ ref('stg_erp__clients') }}
