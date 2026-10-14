-- grain: one row per production module (recipe / production line) per tenant
with source as (
    select * from {{ source('erp', 'production_modules') }}
)

select
    {{ tenant_key('id') }}                    as production_module_key,
    tenant_id,
    {{ clean_text('name') }}                  as module_name,
    {{ tenant_key('finished_product_id') }}   as finished_product_key,
    {{ to_num('finished_product_quantity') }} as standard_output_quantity,
    {{ to_bool('is_active') }}                as is_active,
    deleted_at is not null                    as is_deleted
from source
