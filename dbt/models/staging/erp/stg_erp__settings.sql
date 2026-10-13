-- grain: one row per tenant (the ERP's company settings record)
-- only non-identifying columns were ingested (see KEEP_COLUMNS in load_raw.py)
with settings as (
    select * from {{ source('erp', 'settings') }}
),

currencies as (
    select tenant_id, {{ to_int('id') }} as currency_id, {{ clean_text('code') }} as currency_code
    from {{ source('erp', 'currencies') }}
),

tenants as (
    select * from {{ ref('tenants') }}
)

select
    s.tenant_id,
    {{ tenant_key('s.id', 's.tenant_id') }}                    as settings_key,
    c.currency_code                             as source_currency_code,
    t.reporting_currency,
    coalesce(c.currency_code, '') <> t.reporting_currency as has_currency_mismatch,
    {{ tenant_key('s.client_id', 's.tenant_id') }}             as default_client_key,
    {{ tenant_key('s.warehouse_id', 's.tenant_id') }}          as default_warehouse_key,
    {{ clean_text('s.default_language') }}      as default_language
from settings as s
left join currencies as c
    on c.tenant_id = s.tenant_id
   and c.currency_id = {{ to_int('s.currency_id') }}
left join tenants as t
    on t.tenant_id = s.tenant_id
