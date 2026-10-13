# dbt — fortix_analytics

Transforms `raw` (Postgres) into `staging` → `intermediate` → `marts`.

## Setup (once)

```cmd
.venv\Scripts\activate
pip install dbt-postgres
copy dbt\profiles.yml.example dbt\profiles.yml
```

`dbt\profiles.yml` is git-ignored; it reads the `WAREHOUSE_*` values that `scripts\dbt.cmd` loads from `.env`.

## Run (from the project root)

```cmd
scripts\dbt.cmd debug        :: check the connection
scripts\dbt.cmd build        :: seeds + models + tests
scripts\dbt.cmd source freshness
scripts\dbt.cmd docs generate && scripts\dbt.cmd docs serve
```

## Layout

| Folder | Schema | Materialisation | Naming |
|---|---|---|---|
| `seeds/` | `reference` | table | `tenants` |
| `models/staging/erp/` | `staging` | view | `stg_erp__<table>` |
| `models/intermediate/` | `intermediate` | view | `int_<entity>_<verb>` |
| `models/marts/` | `marts` | table | `fct_<process>`, `dim_<entity>` |
