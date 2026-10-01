# Local discovery database (Docker)

Loads the five customer SQL dumps into a local MariaDB 11.4 container for Project 1 (data discovery).
Customers are anonymized as `customer_a` … `customer_e`; the real names exist only in the local, git-ignored file `data/customer_mapping.txt`.

## One-time setup

1. Install and start **Docker Desktop**.
2. In the project folder, create `.env` from the template and set a password:
   ```cmd
   copy .env.example .env
   ```
   Fill in `MARIADB_ROOT_PASSWORD` (any strong local password). `.env` is git-ignored.
3. Put the dumps in `data\raw\` and create `data\customer_mapping.txt`:
   ```
   # anonymized_db   dump_file
   customer_a   <file>.sql
   customer_b   <file>.sql
   ```

## Start and load

```cmd
docker compose up -d
docker compose ps                         :: wait until STATUS shows (healthy)
docker exec fortix-mariadb bash /setup/load_customers.sh
```

Re-running the load script drops and reloads every customer database.

## Connect

| Setting  | Value |
|----------|-------|
| Host     | `127.0.0.1` |
| Port     | `3307` (or `MARIADB_PORT` in `.env`) |
| User     | `root` |
| Password | `MARIADB_ROOT_PASSWORD` from `.env` |

Command line inside the container:
```cmd
docker exec -it fortix-mariadb mariadb -uroot -p customer_b
```

## Stop / reset

```cmd
docker compose stop          :: stop, keep data
docker compose down -v       :: remove container AND loaded databases
```

## Run profiling queries

Runs every file in `sql/profiling/` and saves each result as a TSV file in `data\processed\profiling\` (git-ignored; open in Excel or VS Code):

```cmd
docker exec fortix-mariadb bash /sql/setup/run_profiling.sh
```

Run a single file by its prefix:

```cmd
docker exec fortix-mariadb bash /sql/setup/run_profiling.sh 01_*
```
