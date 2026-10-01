# CLAUDE.md

Context for AI assistants working in this repository.

## Project
Analytics engineering platform for multi-business ERP data (Fortix Tech). Source data lives in a cloud MySQL ERP database; it is loaded into a warehouse, transformed with dbt, and served to BI dashboards and AI analytics.

## Layout
- `ingestion/python/` — extract-load scripts
- `sql/profiling|validation|analysis/` — standalone SQL, not part of dbt
- `dbt/` — all transformations (staging → intermediate → marts)
- `docs/` — architecture, data dictionary, decision records
- `dashboards/` — BI assets
- `tests/` — Python tests

## Conventions
- SQL: lowercase keywords, snake_case names, one CTE per logical step.
- dbt models: `stg_<source>__<table>`, `int_<entity>_<verb>`, `fct_<process>`, `dim_<entity>`.
- Every dbt model gets a description and at least `unique` / `not_null` tests on its primary key.
- Record significant design choices in `docs/decisions/` as numbered ADRs.

## Rules
- Never commit credentials. Secrets go in `.env` (git-ignored); keep `.env.example` updated with variable names only.
- Do not commit raw ERP data extracts.
