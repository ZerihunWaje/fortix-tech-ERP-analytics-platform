-- grain: one row per production batch per tenant (manufacturing customers only)
-- operator_id / created_by (employees) and free-text notes are not selected
with source as (
    select * from {{ source('erp', 'productions') }}
),

renamed as (
    select
        {{ tenant_key('id') }}                    as production_key,
        tenant_id,
        {{ to_int('id') }}                        as production_id,
        {{ clean_text('"Ref"') }}                 as production_ref,
        {{ clean_text('batch') }}                 as batch_code,
        {{ to_date('date') }}                     as production_date,
        {{ tenant_key('production_module_id') }}  as production_module_key,
        {{ tenant_key('warehouse_id') }}          as warehouse_key,
        {{ tenant_key('shift_id') }}              as shift_key,
        {{ tenant_key('finished_product_id') }}   as main_product_key,
        {{ to_num('finished_product_quantity') }} as main_product_quantity,
        lower({{ clean_text('statut') }})         as production_status,
        {{ to_ts('created_at') }}                 as created_at,
        {{ to_ts('deleted_at') }}                 as deleted_at,
        deleted_at is not null                    as is_deleted
    from source
)

select * from renamed
