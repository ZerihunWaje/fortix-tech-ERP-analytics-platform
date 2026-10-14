-- grain: one row per ERP customer (tenant)
with tenants as (
    select * from {{ ref('tenants') }}
),

settings as (
    select * from {{ ref('stg_erp__settings') }}
)

select
    t.tenant_id,
    t.tenant_label,
    t.business_type,
    t.reporting_currency,
    s.source_currency_code,
    coalesce(s.has_currency_mismatch, false) as has_currency_mismatch
from tenants as t
left join settings as s
    on s.tenant_id = t.tenant_id
