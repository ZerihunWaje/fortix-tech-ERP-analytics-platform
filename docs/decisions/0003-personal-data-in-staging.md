# ADR 0003 — Personal data is removed in dbt staging

- **Status:** Accepted
- **Date:** 2026-10-13
- **Phase:** Project 2 — Pipeline, dbt modelling and Power BI

## Context

`raw` is a faithful copy of the ERP tables (ADR 0002). Some of them hold personal or identifying data:
client names, phones, emails, addresses, tax numbers, car licence plates, and warehouse contact details.
Credential, login, HR and bank tables are already excluded at ingestion (`ingestion/python/load_raw.py`).

Analytics and Power BI never need to identify a person, and this repository and its screenshots are public.

## Decision

1. `raw` stays local and is never exposed to BI tools.
2. Staging models **do not select** personal columns. Nothing downstream of staging can see them.
3. Where an entity needs a readable name, staging builds a neutral label from the id (`Client 0042`, `Warehouse 03`).
4. `stg_erp__clients.client_name_hash` (md5 of tenant + lower-cased name) allows duplicate detection without revealing names.
5. Customers (tenants) are only ever named `customer_a` … `customer_e` / `Customer A` … `Customer E` (ADR 0001).
6. Product and category names are kept: they describe goods, not people, and are needed for analysis.

## Consequences

- Power BI connects to `marts` (and `staging` at most), never to `raw`.
- Adding a new source column means deciding explicitly whether it is personal before selecting it.
- The md5 hash is not anonymisation in the strict sense (names could be guessed and hashed); it is kept out of marts.
