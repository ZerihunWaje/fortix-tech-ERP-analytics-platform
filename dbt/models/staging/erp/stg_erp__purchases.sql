-- grain: one row per purchase (supplier invoice / goods receipt) per tenant
with source as (
    select * from {{ source('erp', 'purchases') }}
),

renamed as (
    select
        {{ tenant_key('id') }}                  as purchase_key,
        tenant_id,
        {{ to_int('id') }}                      as purchase_id,
        {{ clean_text('"Ref"') }}               as purchase_ref,
        {{ to_date('date') }}                   as purchase_date,
        {{ tenant_key('provider_id') }}         as supplier_key,
        {{ tenant_key('warehouse_id') }}        as warehouse_key,
        lower({{ clean_text('statut') }})         as purchase_status,
        lower({{ clean_text('payment_statut') }}) as payment_status,
        {{ to_num('tax_rate') }}                as tax_rate,
        {{ to_num('"TaxNet"') }}                as tax_amount,
        {{ to_num('discount') }}                as discount_amount,
        {{ to_num('shipping') }}                as shipping_amount,
        {{ to_num('"GrandTotal"') }}            as grand_total,
        {{ to_num('paid_amount') }}             as paid_amount,
        {{ to_num('"GrandTotal"') }} - coalesce({{ to_num('paid_amount') }}, 0) as amount_due,
        {{ to_ts('created_at') }}               as created_at,
        {{ to_ts('deleted_at') }}               as deleted_at,
        deleted_at is not null                  as is_deleted
    from source
)

select * from renamed
