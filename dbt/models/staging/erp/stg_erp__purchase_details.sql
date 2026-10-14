-- grain: one row per product line on a purchase per tenant
with source as (
    select * from {{ source('erp', 'purchase_details') }}
),

renamed as (
    select
        {{ tenant_key('id') }}                  as purchase_line_key,
        tenant_id,
        {{ tenant_key('purchase_id') }}         as purchase_key,
        {{ tenant_key('product_id') }}          as product_key,
        {{ tenant_key('product_variant_id') }}  as product_variant_key,
        {{ tenant_key('purchase_unit_id') }}    as purchase_unit_key,
        {{ to_num('quantity') }}                as quantity,
        {{ to_num('cost') }}                    as unit_cost,
        {{ to_num('discount') }}                as discount,
        {{ to_num('"TaxNet"') }}                as tax_rate,
        {{ to_num('total') }}                   as line_total,
        {{ to_ts('created_at') }}               as created_at
    from source
)

select * from renamed
