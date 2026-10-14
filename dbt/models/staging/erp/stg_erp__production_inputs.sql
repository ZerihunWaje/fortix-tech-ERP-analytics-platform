-- grain: one row per raw material consumed in a production batch
with source as (
    select * from {{ source('erp', 'production_consumed_products') }}
)

select
    {{ tenant_key('id') }}                  as production_input_key,
    tenant_id,
    {{ tenant_key('production_id') }}       as production_key,
    {{ tenant_key('product_id') }}          as product_key,
    {{ tenant_key('warehouse_id') }}        as warehouse_key,
    {{ to_num('quantity') }}                as quantity,
    {{ to_num('unit_cost') }}               as unit_cost,
    {{ to_num('total_cost') }}              as total_cost
from source
