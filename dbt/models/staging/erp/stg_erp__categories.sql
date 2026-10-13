-- grain: one row per product category per tenant
with source as (
    select * from {{ source('erp', 'categories') }}
),

renamed as (
    select
        {{ tenant_key('id') }}                  as category_key,
        tenant_id,
        {{ to_int('id') }}                      as category_id,
        {{ clean_text('code') }}                as category_code,
        {{ clean_text('name') }}                as category_name,
        {{ to_ts('created_at') }}               as created_at,
        {{ to_ts('deleted_at') }}               as deleted_at,
        deleted_at is not null                  as is_deleted
    from source
)

select * from renamed
