# CLAUDE.md — Fortechx Analytics Platform

Instructions for AI assistants working in this repository.

## Project overview

This repository contains an analytics engineering platform for **Fortechx Solutions**, an Ethiopian ERP startup serving multiple business customers.

The project transforms ERP operational data into reliable, analytics-ready datasets for BI and advanced analytics. Source data lives in a cloud MySQL ERP database.

## Main goals

- Understand and profile ERP source data
- Build reusable data ingestion pipelines
- Create an analytical data model
- Implement dbt transformations
- Implement automated data quality checks
- Build reusable business metrics
- Support Power BI and Tableau analytics
- Design the platform to eventually support 100+ ERP customers
- Explore AI-powered analytics after the core data platform is reliable

## Engineering principles

- Prefer simple solutions over unnecessary complexity.
- Prefer free and open-source technologies where practical.
- Do not introduce expensive infrastructure without justification.
- Do not expose customer data.
- Never commit credentials or secrets.
- Do not assume business meaning without evidence.
- Clearly document assumptions.
- Keep transformations reproducible.
- Add tests to important models.
- Make incremental changes.
- Document important architectural decisions.

## Data modeling

Conceptual layers:

```
Source → Raw → Staging → Intermediate → Marts → BI / Analytics
```

- **Staging** models primarily clean and standardize source data.
- **Intermediate** models contain reusable transformation logic.
- **Mart** models represent business-ready analytical entities.
- Every fact table must have a clearly documented **grain**.

### Naming conventions

- dbt models: `stg_<source>__<table>`, `int_<entity>_<verb>`, `fct_<process>`, `dim_<entity>`
- SQL: lowercase keywords, snake_case names, one CTE per logical step
- Every dbt model gets a description and at least `unique` / `not_null` tests on its primary key

## Repository layout

- `data/` — local datasets only (raw / interim / processed); git-ignored, never committed or pushed
- `docs/architecture/` — diagrams, data flow, tech stack
- `docs/data_dictionary/` — table and column definitions
- `docs/decisions/` — numbered architecture decision records (ADRs), e.g. `0001-<title>.md`
- `ingestion/python/` — extract-load scripts
- `sql/profiling/`, `sql/validation/`, `sql/analysis/` — standalone SQL, not part of dbt
- `dbt/` — all transformations
- `dashboards/` — Power BI / Tableau assets
- `tests/` — Python and pipeline tests

## Development workflow

Before making a significant change:

1. Explain the proposed approach.
2. Identify affected files.
3. Implement the smallest reasonable change.
4. Run relevant tests.
5. Review the result.
6. Document important decisions.

Do not generate large amounts of code before the architecture and requirements are understood.

## Git

Use small logical commits with conventional prefixes:

```
feat: add sales staging model
feat: add customer dimension
test: add sales data quality tests
docs: add ERP data dictionary
fix: correct invoice date transformation
```

## Security and data handling

- Secrets go in `.env` (git-ignored); keep `.env.example` updated with variable names only.
- Do not commit raw ERP data extracts or any customer-identifiable data.
