-- 02 Column inventory
-- One row per column per customer database, including the declared FK target.
-- Output: data/processed/profiling/02_column_inventory.tsv

with fk_targets as (
    select
        table_schema,
        table_name,
        column_name,
        concat(referenced_table_name, '.', referenced_column_name) as references_column
    from information_schema.key_column_usage
    where referenced_table_name is not null
      and left(table_schema, 9) = 'customer_'
)

select
    c.table_schema                 as customer_db,
    c.table_name,
    c.ordinal_position,
    c.column_name,
    c.column_type,
    c.data_type,
    c.is_nullable,
    c.column_key,
    coalesce(c.column_default, '') as column_default,
    c.extra,
    coalesce(fk.references_column, '') as references_column,
    replace(c.column_comment, '\t', ' ') as column_comment
from information_schema.columns as c
left join fk_targets as fk
    on  fk.table_schema = c.table_schema
    and fk.table_name   = c.table_name
    and fk.column_name  = c.column_name
where left(c.table_schema, 9) = 'customer_'
order by c.table_name, c.table_schema, c.ordinal_position;
