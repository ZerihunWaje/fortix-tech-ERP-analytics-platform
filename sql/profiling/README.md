# Profiling

Source-data exploration queries for Project 1 (data discovery). Each file returns one result set
and runs against all five anonymized customer databases (`customer_a` … `customer_e`).

| File | Question it answers |
|---|---|
| `01_table_inventory.sql` | What tables exist per customer, how many rows, which primary key, how many FKs? |
| `02_column_inventory.sql` | What columns and data types exist, which are nullable, what do they reference? |
| `03_foreign_keys.sql` | Which relationships are declared, and with which update/delete rules? |
| `04_table_presence_matrix.sql` | Which tables are shared by all customers and which are customer-specific? |

Run with `docker exec fortix-mariadb bash /sql/setup/run_profiling.sh` (see `sql/setup/README.md`).
Results are written to `data/processed/profiling/` and are never committed.
