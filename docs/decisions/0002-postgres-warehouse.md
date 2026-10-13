# ADR 0002 — Local PostgreSQL as the analytics warehouse

- **Status:** Accepted
- **Date:** 2026-10-13
- **Phase:** Project 2 — Pipeline, dbt modelling and Power BI

## Context

ADR 0001 left the target warehouse open. The five customer databases now load into local MariaDB (`customer_a` … `customer_e`). The next layers need a single analytical database that:

- holds every customer's data together, separated by a `tenant_id` column
- runs dbt Core with a mature, free adapter
- Power BI Desktop can connect to without extra licences or gateways
- keeps customer data on this machine (no cloud upload)

## Decision

Run **PostgreSQL 16** in Docker as service `postgres` (container `fortix-warehouse`), bound to `127.0.0.1:5433`, with these schemas:

| Schema | Owner | Purpose |
|---|---|---|
| `raw` | Python ingestion | 1:1 copies of source tables + `tenant_id`, `_loaded_at` |
| `staging` | dbt | cleaned, typed, personal data masked |
| `intermediate` | dbt | reusable joins and logic |
| `marts` | dbt | facts and dimensions for Power BI |

MariaDB stays as the **source copy** only; nothing is transformed there.

## Alternatives considered

| Option | Why not |
|---|---|
| Transform inside MariaDB | Mixes source and analytics; one database per customer makes cross-customer models awkward |
| DuckDB | Excellent locally, but Power BI needs an ODBC driver and concurrent access is limited |
| Cloud warehouse (BigQuery, Snowflake) | Cost, and customer data would leave the machine (conflicts with ADR 0001) |
| SQL Server | Heavier image; Postgres is the more common open-source dbt target |

## Consequences

- Power BI connects with its built-in PostgreSQL connector (Import mode).
- Credentials live in `.env` (`WAREHOUSE_*`), never in Git.
- Moving to a managed Postgres later (e.g. for 100+ customers) needs no model changes, only connection settings.
