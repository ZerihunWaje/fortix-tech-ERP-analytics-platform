{% docs __overview__ %}
# Fortix tech ERP analytics platform

Analytics models for five businesses running the ZemenStock ERP (anonymised as **Customer A–E**).

**Flow:** MariaDB dumps → Python ingestion (`raw`) → dbt `staging` (typed, personal data removed) → `marts` (star schema) → Power BI.

| Area | Facts | Dimensions |
|---|---|---|
| Sales | `fct_sales`, `fct_sales_lines` | `dim_client`, `dim_product`, `dim_warehouse`, `dim_date`, `dim_tenant` |
| Inventory | `fct_stock_snapshot` | `dim_product`, `dim_warehouse` |
| Purchasing | `fct_purchases`, `fct_purchase_lines` | `dim_supplier`, `dim_product` |
| Production | `fct_production_batches`, `fct_production_outputs` | `dim_product` |
| Quality | `dq_checks`, `dq_load_summary` | `dim_tenant` |

**Key rules**
- Every key is `tenant_id-<source id>`, because source ids repeat across customer databases.
- Soft-deleted records are excluded from facts and counted in `dq_checks`.
- Revenue counts completed sales only. Margins use the product's *current* cost (no cost history in the ERP).
- No names, phones, emails or addresses leave staging (ADR 0003).

See the repository's `docs/decisions/` for architecture decision records.
{% enddocs %}
