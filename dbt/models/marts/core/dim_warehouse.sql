-- grain: one row per warehouse per tenant (names and contacts removed, ADR 0003)
select
    warehouse_key,
    tenant_id,
    warehouse_label,
    country,
    is_deleted
from {{ ref('stg_erp__warehouses') }}
