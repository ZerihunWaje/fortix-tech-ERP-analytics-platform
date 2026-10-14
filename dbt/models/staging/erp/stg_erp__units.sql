-- grain: one row per unit of measure per tenant
-- a unit converts to its base unit with: quantity_in_base = quantity <operator> operator_value
with source as (
    select * from {{ source('erp', 'units') }}
),

renamed as (
    select
        {{ tenant_key('id') }}                  as unit_key,
        tenant_id,
        {{ to_int('id') }}                      as unit_id,
        {{ clean_text('name') }}                as unit_name,
        {{ clean_text('"ShortName"') }}         as unit_short_name,
        {{ tenant_key('base_unit') }}           as base_unit_key,
        {{ clean_text('operator') }}            as conversion_operator,
        {{ to_num('operator_value') }}          as conversion_value,
        {{ to_ts('deleted_at') }}               as deleted_at,
        deleted_at is not null                  as is_deleted
    from source
)

select * from renamed
