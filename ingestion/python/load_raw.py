"""
Extract-load: local MariaDB (customer_a ... customer_e) -> Postgres schema `raw`.

- Copies an explicit allow-list of business tables (see TABLES below).
- Never copies credential / login / HR tables (see ADR 0002 and README).
- Adds `tenant_id` and `_loaded_at` to every row.
- Stores every source value as TEXT; dbt staging does the type casting.
- Full refresh: each run drops and reloads the raw tables.
- Writes one row per tenant and table to raw._load_log.

Run from the project root:
    python ingestion/python/load_raw.py
"""
from __future__ import annotations

import logging
import os
import re
import sys
import uuid
from datetime import datetime, timezone

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, inspect, text
from sqlalchemy.engine import URL, Engine

# --------------------------------------------------------------------------
# What to load. Grouped by business area; anything not listed is NOT copied.
# --------------------------------------------------------------------------
TABLES: dict[str, list[str]] = {
    "sales": [
        "sales", "sale_details", "sale_returns", "sale_return_details",
        "payment_sales", "payment_sale_returns", "quotations", "quotation_details",
        "shipments", "clients",
        "customer_advance_payments", "customer_advance_payment_usages",
    ],
    "purchasing": [
        "purchases", "purchase_details", "purchase_returns", "purchase_return_details",
        "payment_purchases", "payment_purchase_returns", "providers",
    ],
    "inventory": [
        "products", "product_variants", "product_warehouse",
        "categories", "sub_categories", "brands", "units", "warehouses",
        "adjustments", "adjustment_details", "transfers", "transfer_details",
        "stock_audit_sessions", "stock_audit_lines",
    ],
    "finance": ["expenses", "expense_categories", "currencies"],
    "production": [
        "productions", "production_details", "production_consumed_products",
        "production_finished_products", "production_finished_product_wastes",
        "production_wastes", "production_modules", "production_module_materials",
        "blowing_machines", "shifts",
    ],
    "config": ["settings"],
}

# Tables where only some columns are safe/useful to copy.
KEEP_COLUMNS: dict[str, list[str]] = {
    # settings also holds company contact details, logo, SMS config, etc.
    "settings": ["id", "currency_id", "client_id", "warehouse_id", "default_language",
                 "created_at", "updated_at", "deleted_at"],
}

load_dotenv()  # before reading WAREHOUSE_SCHEMA below
TENANT_PATTERN = re.compile(r"^customer_[a-z]$")
RAW_SCHEMA = os.getenv("WAREHOUSE_SCHEMA", "raw")

log = logging.getLogger("load_raw")


# --------------------------------------------------------------------------
# Connections
# --------------------------------------------------------------------------
def env(name: str, default: str | None = None) -> str:
    value = os.getenv(name, default)
    if value in (None, ""):
        sys.exit(f"Missing {name} in .env")
    return value


def source_engine() -> Engine:
    url = URL.create(
        "mysql+pymysql",
        username=env("MARIADB_USER", "root"),
        password=env("MARIADB_ROOT_PASSWORD"),
        host=env("MARIADB_HOST", "127.0.0.1"),
        port=int(env("MARIADB_PORT", "3307")),
        query={"charset": "utf8mb4"},
    )
    return create_engine(url, pool_pre_ping=True)


def warehouse_engine() -> Engine:
    url = URL.create(
        "postgresql+psycopg2",
        username=env("WAREHOUSE_USER", "fortix"),
        password=env("WAREHOUSE_PASSWORD"),
        host=env("WAREHOUSE_HOST", "127.0.0.1"),
        port=int(env("WAREHOUSE_PORT", "5433")),
        database=env("WAREHOUSE_DATABASE", "fortix_warehouse"),
    )
    return create_engine(url, pool_pre_ping=True)


# --------------------------------------------------------------------------
# Extract
# --------------------------------------------------------------------------
def list_tenants(src: Engine) -> list[str]:
    with src.connect() as conn:
        names = [r[0] for r in conn.execute(text("SHOW DATABASES"))]
    tenants = sorted(n for n in names if TENANT_PATTERN.match(n))
    if not tenants:
        sys.exit("No customer_x databases found. Run sql/setup/load_customers.sh first.")
    return tenants


def tenant_tables(src: Engine, tenant: str) -> set[str]:
    return set(inspect(src).get_table_names(schema=tenant))


def as_text(df: pd.DataFrame) -> pd.DataFrame:
    """Every value becomes a string; NULL stays NULL. Staging casts types."""
    out = df.astype(object)
    return out.where(out.isna(), out.map(str)).where(out.notna(), None)


def extract(src: Engine, tenant: str, table: str) -> pd.DataFrame:
    cols = KEEP_COLUMNS.get(table)
    if cols:
        present = {c["name"] for c in inspect(src).get_columns(table, schema=tenant)}
        select = ", ".join(f"`{c}`" for c in cols if c in present)
    else:
        select = "*"
    with src.connect() as conn:
        result = conn.execute(text(f"SELECT {select} FROM `{tenant}`.`{table}`"))
        # dtype=object keeps integers as integers (pd.read_sql turns an int
        # column with NULLs into floats, e.g. 12 -> "12.0").
        df = pd.DataFrame(result.fetchall(), columns=list(result.keys()), dtype=object)
    return as_text(df)


# --------------------------------------------------------------------------
# Load
# --------------------------------------------------------------------------
def prepare_warehouse(wh: Engine) -> None:
    with wh.begin() as conn:
        conn.execute(text(f'CREATE SCHEMA IF NOT EXISTS "{RAW_SCHEMA}"'))
        conn.execute(text(f'''
            CREATE TABLE IF NOT EXISTS "{RAW_SCHEMA}"._load_log (
                run_id      text,
                tenant_id   text,
                table_name  text,
                row_count   integer,
                status      text,
                loaded_at   timestamptz
            )'''))


def load_table(wh: Engine, table: str, df: pd.DataFrame) -> None:
    with wh.begin() as conn:
        # CASCADE: dbt views on raw are rebuilt by `dbt run` afterwards.
        conn.execute(text(f'DROP TABLE IF EXISTS "{RAW_SCHEMA}"."{table}" CASCADE'))
    df.to_sql(table, wh, schema=RAW_SCHEMA, index=False,
              if_exists="replace", method="multi", chunksize=1000)


def write_log(wh: Engine, rows: list[dict]) -> None:
    if rows:
        pd.DataFrame(rows).to_sql("_load_log", wh, schema=RAW_SCHEMA,
                                  index=False, if_exists="append")


# --------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------
def main() -> None:
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")

    src, wh = source_engine(), warehouse_engine()
    run_id = uuid.uuid4().hex[:12]
    loaded_at = datetime.now(timezone.utc)

    tenants = list_tenants(src)
    available = {t: tenant_tables(src, t) for t in tenants}
    log.info("Run %s: tenants %s", run_id, ", ".join(tenants))
    prepare_warehouse(wh)

    log_rows: list[dict] = []
    all_tables = [t for group in TABLES.values() for t in group]

    for table in all_tables:
        frames = []
        for tenant in tenants:
            if table not in available[tenant]:
                log_rows.append(dict(run_id=run_id, tenant_id=tenant, table_name=table,
                                     row_count=0, status="missing_in_source", loaded_at=loaded_at))
                continue
            df = extract(src, tenant, table)
            df.insert(0, "tenant_id", tenant)
            df["_loaded_at"] = loaded_at.isoformat()
            frames.append(df)
            log_rows.append(dict(run_id=run_id, tenant_id=tenant, table_name=table,
                                 row_count=len(df), status="loaded", loaded_at=loaded_at))

        if not frames:
            log.info("%-36s skipped (no tenant has it)", table)
            continue
        # concat aligns columns: a column one tenant lacks becomes NULL for it
        combined = pd.concat(frames, ignore_index=True, sort=False)
        combined = combined.astype(object).where(combined.notna(), None)
        load_table(wh, table, combined)
        log.info("%-36s %7d rows from %d tenant(s)", table, len(combined), len(frames))

    write_log(wh, log_rows)
    total = sum(r["row_count"] for r in log_rows)
    log.info("Done. %d rows loaded into schema %s (run %s).", total, RAW_SCHEMA, run_id)


if __name__ == "__main__":
    main()
