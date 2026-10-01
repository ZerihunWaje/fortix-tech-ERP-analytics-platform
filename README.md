# Fortix tech Analytics Platform

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

Planned data flow:

```
Source (cloud MySQL ERP) → Raw → Staging → Intermediate → Marts → BI / Analytics
```

## Project status

Currently in the **data discovery and architecture** phase.

| Step | Area | Main folder | Status |
|---|---|---|---|
| 01 | Project Architecture | `docs/architecture/`, `docs/decisions/` | In progress |
| 02 | Data Discovery | `sql/profiling/`, `docs/data_dictionary/` | In progress |
| 03 | Data Modeling | `docs/architecture/`, `dbt/` | Not started |
| 04 | dbt Development | `dbt/` | Not started |
| 05 | Data Quality | `dbt/` tests, `sql/validation/`, `tests/` | Not started |
| 06 | Pipeline / Automation | `ingestion/python/` | Not started |
| 07 | BI & Analytics | `dashboards/`, `sql/analysis/` | Not started |
| 08 | AI Analytics | to be added | Not started |
| 09 | Documentation & Portfolio | `docs/`, this README | Not started |

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
