-- 01 Table inventory
-- One row per customer database and table: exact row count, column count,
-- primary key columns and number of outgoing (declared) foreign keys.
-- Exact counts need one count(*) per table, so the query is generated dynamically.
-- Output: data/processed/profiling/01_table_inventory.tsv

set session group_concat_max_len = 10000000;

set @sql = (
    select group_concat(
        concat(
            'select ', quote(t.table_schema), ' as customer_db, ',
            quote(t.table_name), ' as table_name, ',
            'count(*) as row_count, ',
            coalesce(c.column_count, 0), ' as column_count, ',
            quote(coalesce(p.primary_key, '')), ' as primary_key, ',
            coalesce(f.fk_count, 0), ' as outgoing_fk_count ',
            'from `', t.table_schema, '`.`', t.table_name, '`'
        )
        separator ' union all '
    )
    from information_schema.tables as t
    left join (
        select table_schema, table_name, count(*) as column_count
        from information_schema.columns
        group by table_schema, table_name
    ) as c
        on c.table_schema = t.table_schema and c.table_name = t.table_name
    left join (
        select table_schema, table_name,
               group_concat(column_name order by ordinal_position) as primary_key
        from information_schema.key_column_usage
        where constraint_name = 'PRIMARY'
        group by table_schema, table_name
    ) as p
        on p.table_schema = t.table_schema and p.table_name = t.table_name
    left join (
        select constraint_schema, table_name, count(*) as fk_count
        from information_schema.referential_constraints
        group by constraint_schema, table_name
    ) as f
        on f.constraint_schema = t.table_schema and f.table_name = t.table_name
    where left(t.table_schema, 9) = 'customer_'
      and t.table_type = 'BASE TABLE'
);

set @sql = concat('select * from (', @sql, ') as inventory order by table_name, customer_db');

prepare stmt from @sql;
execute stmt;
deallocate prepare stmt;
