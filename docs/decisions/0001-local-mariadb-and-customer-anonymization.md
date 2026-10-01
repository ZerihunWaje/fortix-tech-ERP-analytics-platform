# ADR 0001 — Local MariaDB in Docker and anonymized customer labels for discovery

- **Status:** Accepted
- **Date:** 2026-10-01
- **Phase:** Project 1 — ERP Data Discovery & Data Quality Assessment

## Context

Fortix tech provided five SQL dumps, one per ERP customer. Initial inspection showed:

- All five are phpMyAdmin dumps exported from **MariaDB 11.4** (utf8mb4, no views, triggers or procedures).
- They contain customer business data, personal data (names, phones, emails, addresses) and secrets (credentials and tokens stored in application tables).
- Database names identify the customers; some appear to be personal names.
- This repository is public.

Discovery must be reproducible (SQL checked into `sql/profiling/` and `sql/validation/`), but no data or customer identity may reach GitHub.

## Decision

1. **Run discovery against a local MariaDB 11.4 container** (`docker-compose.yml`), matching the source server version so dump syntax, types and collations behave the same. The port is bound to `127.0.0.1` only.
2. **Load each dump into an anonymized database**, `customer_a` … `customer_e`, using `sql/setup/load_customers.sh`.
3. **Keep the mapping from label to real customer only in `data/customer_mapping.txt`**, which is git-ignored along with all dumps.
4. **Committed artifacts contain only SQL, schema metadata and aggregated results** (counts, ranges, percentages) using the A–E labels — never row-level values.

## Alternatives considered

| Option | Why not |
|---|---|
| Parse the dump files directly (Python) | Fine for quick triage, but not real SQL; harder to reproduce and review |
| Local MySQL / XAMPP install | Version differences from MariaDB 11.4; less reproducible across machines |
| Cloud warehouse | Cost and customer data leaving the local machine before it is understood |
| Keep real customer names in docs | Exposes customer identity in a public repository |

## Consequences

- Anyone reproducing the work needs Docker Desktop and the dumps placed locally.
- Findings shared publicly cannot be traced to a specific customer without the local mapping.
- The choice of target warehouse for later phases remains open and will get its own ADR.
