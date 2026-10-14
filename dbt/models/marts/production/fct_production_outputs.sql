-- grain: one row per finished product made in a production batch; batches soft-deleted excluded
with outputs as (
    select * from {{ ref('stg_erp__production_outputs') }}
),

batches as (
    select * from {{ ref('stg_erp__productions') }}
    where not is_deleted
)

select
    o.production_output_key,
    o.production_key,
    b.tenant_id,
    b.production_date,
    b.warehouse_key,
    o.product_key,
    o.quantity
from outputs as o
inner join batches as b
    on b.production_key = o.production_key
