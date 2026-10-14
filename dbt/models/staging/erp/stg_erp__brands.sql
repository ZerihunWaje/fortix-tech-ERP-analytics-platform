-- grain: one row per product brand per tenant
with source as (
    select * from {{ source('erp', 'brands') }}
),

renamed as (
    select
        {{ tenant_key('id') }}                  as brand_key,
        tenant_id,
        {{ to_int('id') }}                      as brand_id,
        {{ clean_text('name') }}                as brand_name,
        {{ to_ts('created_at') }}               as created_at,
        {{ to_ts('deleted_at') }}               as deleted_at,
        deleted_at is not null                  as is_deleted
    from source
)

select * from renamed
