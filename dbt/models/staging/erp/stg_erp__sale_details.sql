-- grain: one row per sale line (product on an invoice) per tenant
with source as (
    select * from {{ source('erp', 'sale_details') }}
),

renamed as (
    select
        {{ tenant_key('id') }}                  as sale_line_key,
        tenant_id,
        {{ to_int('id') }}                      as sale_line_id,
        {{ tenant_key('sale_id') }}             as sale_key,
        {{ tenant_key('product_id') }}          as product_key,
        {{ tenant_key('product_variant_id') }}  as product_variant_key,
        {{ tenant_key('sale_unit_id') }}        as sale_unit_key,
        {{ to_date('date') }}                   as sale_date,
        {{ to_num('quantity') }}                as quantity,
        {{ to_num('price') }}                   as unit_price,
        {{ to_num('discount') }}                as discount,
        {{ clean_text('discount_method') }}     as discount_method,
        {{ to_num('"TaxNet"') }}                as tax_rate,
        {{ clean_text('tax_method') }}          as tax_method,
        {{ to_num('total') }}                   as line_total,
        {{ to_ts('created_at') }}               as created_at,
        {{ to_ts('updated_at') }}               as updated_at
    from source
)

select * from renamed
