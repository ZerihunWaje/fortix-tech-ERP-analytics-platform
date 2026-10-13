-- grain: one row per sale (invoice) per tenant
with source as (
    select * from {{ source('erp', 'sales') }}
),

renamed as (
    select
        {{ tenant_key('id') }}                  as sale_key,
        tenant_id,
        {{ to_int('id') }}                      as sale_id,
        {{ clean_text('"Ref"') }}               as sale_ref,
        {{ to_date('date') }}                   as sale_date,
        {{ tenant_key('client_id') }}           as client_key,
        {{ tenant_key('warehouse_id') }}        as warehouse_key,
        {{ tenant_key('user_id') }}             as user_key,
        {{ to_bool('is_pos') }}                 as is_pos,
        lower({{ clean_text('statut') }})         as sale_status,
        lower({{ clean_text('payment_statut') }}) as payment_status,
        lower({{ clean_text('shipping_status') }}) as shipping_status,
        {{ to_num('tax_rate') }}                as tax_rate,
        {{ to_num('"TaxNet"') }}                as tax_amount,
        {{ to_num('discount') }}                as discount_amount,
        {{ to_num('shipping') }}                as shipping_amount,
        {{ to_num('"GrandTotal"') }}            as grand_total,
        {{ to_num('paid_amount') }}             as paid_amount,
        {{ to_num('"GrandTotal"') }} - coalesce({{ to_num('paid_amount') }}, 0) as amount_due,
        {{ to_ts('created_at') }}               as created_at,
        {{ to_ts('updated_at') }}               as updated_at,
        {{ to_ts('deleted_at') }}               as deleted_at,
        deleted_at is not null                  as is_deleted
    from source
)

select * from renamed
