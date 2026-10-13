-- grain: one row per product per tenant
with source as (
    select * from {{ source('erp', 'products') }}
),

renamed as (
    select
        {{ tenant_key('id') }}                  as product_key,
        tenant_id,
        {{ to_int('id') }}                      as product_id,
        {{ clean_text('code') }}                as product_code,
        {{ clean_text('name') }}                as product_name,
        {{ tenant_key('category_id') }}         as category_key,
        {{ tenant_key('sub_category_id') }}     as sub_category_key,
        {{ tenant_key('brand_id') }}            as brand_key,
        {{ tenant_key('unit_id') }}             as unit_key,
        lower({{ clean_text('product_type') }}) as product_type,
        {{ to_num('cost') }}                    as unit_cost,
        {{ to_num('price') }}                   as unit_price,
        {{ to_num('stock_alert') }}             as stock_alert_qty,
        {{ to_num('"TaxNet"') }}                as tax_rate,
        {{ to_bool('is_variant') }}             as is_variant,
        {{ to_bool('is_imei') }}                as is_imei,
        {{ to_bool('not_selling') }}            as is_not_selling,
        {{ to_bool('is_active') }}              as is_active,
        {{ to_ts('created_at') }}               as created_at,
        {{ to_ts('updated_at') }}               as updated_at,
        {{ to_ts('deleted_at') }}               as deleted_at,
        deleted_at is not null                  as is_deleted
    from source
)

select * from renamed
