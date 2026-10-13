-- grain: one row per product (variant) per warehouse per tenant: current stock on hand
with source as (
    select * from {{ source('erp', 'product_warehouse') }}
),

renamed as (
    select
        {{ tenant_key('id') }}                  as product_warehouse_key,
        tenant_id,
        {{ tenant_key('product_id') }}          as product_key,
        {{ tenant_key('product_variant_id') }}  as product_variant_key,
        {{ tenant_key('warehouse_id') }}        as warehouse_key,
        {{ to_num('qte') }}                     as quantity_on_hand,
        {{ to_ts('created_at') }}               as created_at,
        {{ to_ts('updated_at') }}               as updated_at,
        {{ to_ts('deleted_at') }}               as deleted_at,
        deleted_at is not null                  as is_deleted
    from source
)

select * from renamed
