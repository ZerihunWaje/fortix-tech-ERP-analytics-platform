# Fortix tech Analytics Platform

[![dbt CI](https://github.com/ZerihunWaje/fortix-tech-ERP-analytics-platform/actions/workflows/dbt-ci.yml/badge.svg)](https://github.com/ZerihunWaje/fortix-tech-ERP-analytics-platform/actions/workflows/dbt-ci.yml)

Building a scalable analytics platform for multi-business ERP data, from cloud MySQL pipelines and dbt transformations to BI dashboards and AI analytics.

## Overview

This project is an end-to-end analytics engineering platform being developed for **Fortix tech Solutions**, an Ethiopian ERP startup serving multiple business customers.

The platform aims to transform operational ERP data into reliable, analytics-ready datasets and reusable business intelligence.

## Objectives

- ERP data discovery and profiling
- Data ingestion
- Analytical data modeling
- dbt transformations
- Data quality testing
- Automated ELT pipelines
- Business KPI modeling
- Power BI / Tableau analytics
- Cross-business analytics
- AI-powered analytics

## Architecture

Architecture documentation will be added to [`docs/architecture/`](docs/architecture/) as the platform develops.

Data flow:

```
ERP dumps (MariaDB) → Python load → Postgres raw → dbt staging → dbt marts (star schema) → Power BI
```

Model documentation: [`docs/data_dictionary/marts.md`](docs/data_dictionary/marts.md).

## Project status

| Step | Area | Main folder | Status |
|---|---|---|---|
| 01 | Project setup & architecture decisions | `docs/decisions/` | Done |
| 02 | Local source (MariaDB) + warehouse (Postgres) in Docker | `docker-compose.yml`, `sql/setup/` | Done |
| 03 | Python ingestion MariaDB → Postgres `raw` | `ingestion/python/` | Done |
| 04 | Personal-data removal in staging (ADR 0003) | `dbt/models/staging/` | Done |
| 05 | dbt staging models | `dbt/models/staging/` | Done |
| 06 | Star schema: sales, inventory, purchasing, production | `dbt/models/marts/` | Done |
| 07 | Data-quality scorecard, dbt docs, data dictionary | `dbt/models/marts/quality/`, `docs/data_dictionary/` | Done |
| 08 | One-command pipeline + GitHub Actions CI | `scripts/`, `.github/workflows/` | Done |
| 09 | Power BI semantic model (measures, row-level security) | `dashboards/` | Next |
| 10 | Power BI report pages | `dashboards/` | Planned |
| 11 | Portfolio write-up | `README.md`, `docs/` | Planned |

## How to run

Prerequisites: Docker Desktop, Python 3.11+, the customer dumps in `data/raw/` (local only) and a filled-in `.env`.

```cmd
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt dbt-postgres
copy dbt\profiles.yml.example dbt\profiles.yml

docker compose up -d --wait
docker exec fortix-mariadb bash /setup/load_customers.sh   :: once, loads the dumps into MariaDB

scripts\run_pipeline.cmd                                   :: ingestion -> dbt build -> dbt docs
scripts\dbt.cmd docs serve --port 8081                     :: browse models, tests and lineage
```

Every push runs `dbt build` on GitHub Actions against synthetic sample data (`tests/fixtures/raw_sample.sql`).

## Technology

- MySQL
- SQL
- Python
- dbt
- PostgreSQL / analytical database
- Power BI / Tableau
- Git / GitHub

## Repository structure

```
├── README.md
├── CLAUDE.md               # Project guidelines for AI coding assistants
├── .gitignore
├── .env.example            # Copy to .env and fill in credentials
├── docker-compose.yml      # Local MariaDB for data discovery
├── data/                   # Local datasets only — git-ignored, never pushed
├── docs/
│   ├── architecture/       # Diagrams, data flow, stack
│   ├── data_dictionary/    # Table and column definitions
│   └── decisions/          # Architecture decision records
├── ingestion/
│   └── python/             # Extract-load scripts (MySQL → warehouse)
├── sql/
│   ├── setup/              # Load customer dumps into local MariaDB
│   ├── profiling/          # Source data exploration
│   ├── validation/         # Reconciliation checks
│   └── analysis/           # Business queries
├── dbt/                    # dbt project
├── dashboards/             # BI files and screenshots
└── tests/                  # Python / pipeline tests
```

## Getting started

```bash
git clone https://github.com/ZerihunWaje/fortix-tech-ERP-analytics-platform.git
cd fortix-tech-ERP-analytics-platform
cp .env.example .env   # then fill in your credentials
```

## Data privacy

This repository does not contain production credentials or publicly exposed customer data.

Public portfolio materials will use anonymized or synthetic data where necessary.
