-- grain: one row per raw material wasted in a production batch
with source as (
    select * from {{ source('erp', 'production_wastes') }}
)

select
    {{ tenant_key('id') }}                  as production_waste_key,
    tenant_id,
    {{ tenant_key('production_id') }}       as production_key,
    {{ tenant_key('raw_material_id') }}     as product_key,
    {{ to_num('waste_quantity') }}          as waste_quantity
from source
