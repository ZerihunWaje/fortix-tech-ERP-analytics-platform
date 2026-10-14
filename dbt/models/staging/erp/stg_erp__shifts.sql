-- grain: one row per work shift per tenant (salary column not selected)
with source as (
    select * from {{ source('erp', 'shifts') }}
)

select
    {{ tenant_key('id') }}                  as shift_key,
    tenant_id,
    {{ clean_text('name') }}                as shift_name,
    {{ clean_text('start_time') }}          as start_time,
    {{ clean_text('end_time') }}            as end_time,
    deleted_at is not null                  as is_deleted
from source
