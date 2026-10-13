# ingestion/python

## load_raw.py — MariaDB → Postgres `raw`

Copies an allow-list of business tables from the local MariaDB customer databases (`customer_a` … `customer_e`) into the Postgres warehouse schema `raw`.

| Rule | Detail |
|---|---|
| Scope | Sales, purchasing, inventory, finance (expenses), production, and `settings` (currency only) |
| Never copied | `users`, `oauth_*`, `password_resets`, `sms_gateway`, `telegram_*`, `servers`, `user_sessions`, `ip_history`, HR/payroll tables, bank and cash accounts |
| Added columns | `tenant_id`, `_loaded_at` |
| Types | All values stored as text; dbt staging casts them |
| Refresh | Full refresh: tables are dropped and reloaded every run |
| Missing tables/columns | Skipped / filled with NULL, recorded in `raw._load_log` |

### Run

```cmd
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python ingestion\python\load_raw.py
```

Needs `MARIADB_ROOT_PASSWORD`, `MARIADB_PORT` and the `WAREHOUSE_*` variables in `.env`, and both Docker containers running.

### Check

```sql
select tenant_id, status, count(*) tables, sum(row_count) rows
from raw._load_log
where run_id = (select run_id from raw._load_log order by loaded_at desc limit 1)
group by 1, 2 order by 1, 2;
```
