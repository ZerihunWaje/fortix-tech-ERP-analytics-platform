-- grain: one row per supplier per tenant
-- privacy (ADR 0003): name, email, phone, address and tax number are NOT selected
with source as (
    select * from {{ source('erp', 'providers') }}
),

renamed as (
    select
        {{ tenant_key('id') }}                  as supplier_key,
        tenant_id,
        {{ to_int('id') }}                      as supplier_id,
        'Supplier ' || lpad(cast({{ to_int('id') }} as text), 3, '0') as supplier_label,
        {{ clean_text('country') }}             as country,
        {{ clean_text('city') }}                as city,
        {{ to_ts('created_at') }}               as created_at,
        {{ to_ts('deleted_at') }}               as deleted_at,
        deleted_at is not null                  as is_deleted
    from source
)

select * from renamed
