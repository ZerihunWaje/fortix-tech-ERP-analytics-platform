-- 04 Table presence matrix
-- Which tables exist in which customer database (1 = present, 0 = absent).
-- Output: data/processed/profiling/04_table_presence_matrix.tsv

select
    table_name,
    max(table_schema = 'customer_a') as customer_a,
    max(table_schema = 'customer_b') as customer_b,
    max(table_schema = 'customer_c') as customer_c,
    max(table_schema = 'customer_d') as customer_d,
    max(table_schema = 'customer_e') as customer_e,
    count(*)                         as customer_count
from information_schema.tables
where left(table_schema, 9) = 'customer_'
  and table_type = 'BASE TABLE'
group by table_name
order by customer_count desc, table_name;
