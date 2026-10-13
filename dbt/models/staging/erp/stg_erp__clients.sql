-- grain: one row per client (buyer) per tenant
-- privacy (ADR 0003): name, phone, email, address, tax number, car type and licence plate
-- are NOT selected. A label and a one-way hash replace the name.
with source as (
    select * from {{ source('erp', 'clients') }}
),

renamed as (
    select
        {{ tenant_key('id') }}                  as client_key,
        tenant_id,
        {{ to_int('id') }}                      as client_id,
        'Client ' || lpad(cast({{ to_int('id') }} as text), 4, '0') as client_label,
        -- lets analysts spot duplicate client records without seeing the name
        md5(tenant_id || '|' || lower(coalesce({{ clean_text('name') }}, ''))) as client_name_hash,
        coalesce(lower(name) like '%walk%in%', false) as is_walk_in_customer,
        {{ clean_text('country') }}             as country,
        {{ clean_text('city') }}                as city,
        {{ to_ts('created_at') }}               as created_at,
        {{ to_ts('deleted_at') }}               as deleted_at,
        deleted_at is not null                  as is_deleted
    from source
)

select * from renamed
