# Data dictionary — marts

All tables live in the Postgres schema `marts`. Amounts are in Ethiopian Birr (ETB). Every row carries `tenant_id` (`customer_a` … `customer_e`).

## Dimensions

| Table | Grain | Key | Main columns |
|---|---|---|---|
| `dim_tenant` | customer | `tenant_id` | label, business type, reporting currency, currency-mismatch flag |
| `dim_date` | day | `date_day` | year, quarter, month, week, weekday, Ethiopian fiscal year (approx. from 8 July) |
| `dim_product` | product per customer | `product_key` | name, category, brand, unit, current cost/price, margin %, stock alert, active/deleted |
| `dim_warehouse` | warehouse per customer | `warehouse_key` | anonymised label, country |
| `dim_client` | client per customer | `client_key` | anonymised label, walk-in flag, city |
| `dim_supplier` | supplier per customer | `supplier_key` | anonymised label, city |

## Facts

| Table | Grain | Measures | Notes |
|---|---|---|---|
| `fct_sales` | sale (invoice) | grand_total, paid_amount, amount_due, units_sold, line_count | revenue = `is_completed`; deleted sales excluded |
| `fct_sales_lines` | product line on a sale | quantity, line_total, est_cost, est_gross_margin | est_* use current product cost |
| `fct_stock_snapshot` | product × warehouse, at last load | quantity_on_hand, stock_value_cost, stock_value_retail | low-stock and negative flags |
| `fct_purchases` | purchase | grand_total, paid_amount, amount_due | spend = `is_received` |
| `fct_purchase_lines` | product line on a purchase | quantity, unit_cost, line_total | |
| `fct_production_batches` | production batch | output_units, material_cost, waste_units, material_cost_per_unit, waste_rate | cost per unit is a blended average |
| `fct_production_outputs` | finished product per batch | quantity | a batch can make 2–3 products |

## Data quality

| Table | Grain | Use |
|---|---|---|
| `dq_checks` | customer × check | scorecard: issues, rows checked, issue rate, status (OK / Warning / Problem) |
| `dq_load_summary` | customer, latest load | tables loaded, rows loaded, load time |
