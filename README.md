# Fortix Tech ERP Analytics Engineering Platform

Building a scalable analytics platform for multi-business ERP data, from cloud MySQL pipelines and dbt transformations to BI dashboards and AI analytics.

## Roadmap

| Step | Area | Main folder | Status |
|---|---|---|---|
| 01 | Project Architecture | `docs/architecture/`, `docs/decisions/` | Not started |
| 02 | Data Discovery | `sql/profiling/`, `docs/data_dictionary/` | Not started |
| 03 | Data Modeling | `docs/architecture/`, `dbt/` | Not started |
| 04 | dbt Development | `dbt/` | Not started |
| 05 | Data Quality | `dbt/` tests, `sql/validation/`, `tests/` | Not started |
| 06 | Pipeline / Automation | `ingestion/python/` | Not started |
| 07 | BI & Analytics | `dashboards/`, `sql/analysis/` | Not started |
| 08 | AI Analytics | to be added | Not started |
| 09 | Documentation & CV | `docs/`, this README | Not started |

## Repository structure

```
├── README.md
├── CLAUDE.md               # Context for AI coding assistants
├── .gitignore
├── .env.example            # Copy to .env and fill in credentials
├── docs/
│   ├── architecture/       # Diagrams, data flow, stack
│   ├── data_dictionary/    # Table and column definitions
│   └── decisions/          # Architecture decision records
├── ingestion/
│   └── python/             # Extract-load scripts (MySQL → warehouse)
├── sql/
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
