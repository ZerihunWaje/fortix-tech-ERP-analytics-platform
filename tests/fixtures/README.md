# tests/fixtures

`raw_sample.sql` — a tiny, **synthetic** copy of the `raw` schema (two fake tenants, a few rows per table, all values invented).
GitHub Actions (`.github/workflows/dbt-ci.yml`) loads it into a fresh Postgres and runs `dbt build`, so every push proves the models and tests still work without touching real customer data.

Keep it in sync with `ingestion/python/load_raw.py`: when a new source table is added there, add a matching table and 1–3 rows here.
