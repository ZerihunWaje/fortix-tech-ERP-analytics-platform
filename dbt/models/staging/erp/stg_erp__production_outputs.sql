-- grain: one row per finished product made in a production batch
with source as (
    select * from {{ source('erp', 'production_finished_products') }}
)

select
    {{ tenant_key('id') }}                    as production_output_key,
    tenant_id,
    {{ tenant_key('production_id') }}         as production_key,
    {{ tenant_key('finished_product_id') }}   as product_key,
    {{ to_num('finished_product_quantity') }} as quantity
from source
