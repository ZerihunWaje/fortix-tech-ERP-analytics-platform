-- grain: one row per tenant for the latest ingestion run (ingestion/python/load_raw.py)
with log as (
    select
        run_id,
        tenant_id,
        table_name,
        row_count,
        status,
        cast(loaded_at as timestamptz) as loaded_at
    from {{ source('erp', '_load_log') }}
),

latest_run as (
    select run_id from log order by loaded_at desc limit 1
)

select
    l.tenant_id,
    l.run_id,
    max(l.loaded_at)                                       as loaded_at,
    count(*) filter (where l.status = 'loaded')            as tables_loaded,
    count(*) filter (where l.status = 'missing_in_source') as tables_not_in_source,
    sum(l.row_count)                                       as rows_loaded
from log as l
inner join latest_run as r on r.run_id = l.run_id
group by l.tenant_id, l.run_id
