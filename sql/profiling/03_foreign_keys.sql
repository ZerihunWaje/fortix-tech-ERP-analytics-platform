-- 03 Declared foreign keys
-- One row per FK column, with the referenced table/column and the
-- ON UPDATE / ON DELETE rules.
-- Output: data/processed/profiling/03_foreign_keys.tsv

select
    k.table_schema            as customer_db,
    k.constraint_name,
    k.table_name              as child_table,
    k.column_name             as child_column,
    k.referenced_table_name   as parent_table,
    k.referenced_column_name  as parent_column,
    r.update_rule,
    r.delete_rule
from information_schema.key_column_usage as k
join information_schema.referential_constraints as r
    on  r.constraint_schema = k.constraint_schema
    and r.constraint_name   = k.constraint_name
    and r.table_name        = k.table_name
where k.referenced_table_name is not null
  and left(k.table_schema, 9) = 'customer_'
order by k.table_name, k.column_name, k.table_schema;
