#!/usr/bin/env bash
# Loads each customer dump into an anonymized database (customer_a ... customer_e).
# Runs INSIDE the container:  docker exec fortix-mariadb bash /setup/load_customers.sh
# Reads the local, git-ignored mapping file data/customer_mapping.txt:
#   customer_a  <dump file name in data/raw/>
# Re-running drops and reloads each database.
set -euo pipefail

MAPPING=/project_data/customer_mapping.txt
DUMPS=/project_data/raw
export MYSQL_PWD="${MARIADB_ROOT_PASSWORD:?MARIADB_ROOT_PASSWORD not set}"

[[ -f "$MAPPING" ]] || { echo "Missing $MAPPING (see sql/setup/README.md)"; exit 1; }

while read -r db file _ || [[ -n "${db:-}" ]]; do
  db="${db%$'\r'}"; file="${file%$'\r'}"
  [[ -z "$db" || "$db" == \#* ]] && continue
  [[ "$db" =~ ^customer_[a-z]$ ]] || { echo "Invalid database name: $db"; exit 1; }
  [[ -f "$DUMPS/$file" ]] || { echo "Dump not found for $db"; exit 1; }

  echo "Loading $db ..."
  mariadb -uroot -e "DROP DATABASE IF EXISTS \`$db\`;
                     CREATE DATABASE \`$db\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
  mariadb -uroot "$db" < "$DUMPS/$file"
  tables=$(mariadb -uroot -N -e "select count(*) from information_schema.tables where table_schema='$db'")
  echo "  $db loaded: $tables tables"
done < "$MAPPING"

echo "Done."
