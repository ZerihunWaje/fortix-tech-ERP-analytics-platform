-- grain: one row per warehouse per tenant
-- privacy (ADR 0003): mobile, email and zip are not selected; names are replaced by a label
with source as (
    select * from {{ source('erp', 'warehouses') }}
),

renamed as (
    select
        {{ tenant_key('id') }}                  as warehouse_key,
        tenant_id,
        {{ to_int('id') }}                      as warehouse_id,
        'Warehouse ' || lpad(cast({{ to_int('id') }} as text), 2, '0') as warehouse_label,
        {{ clean_text('country') }}             as country,
        {{ to_ts('created_at') }}               as created_at,
        {{ to_ts('deleted_at') }}               as deleted_at,
        deleted_at is not null                  as is_deleted
    from source
)

select * from renamed
