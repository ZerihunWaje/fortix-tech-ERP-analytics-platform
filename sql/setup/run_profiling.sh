#!/usr/bin/env bash
# Runs sql/profiling/*.sql inside the container and saves each result as TSV
# in data/processed/profiling/ (local, git-ignored).
#
#   docker exec fortix-mariadb bash /sql/setup/run_profiling.sh          # all files
#   docker exec fortix-mariadb bash /sql/setup/run_profiling.sh 02_*     # one file
#
# Each profiling file must return exactly one result set.
set -euo pipefail

export MYSQL_PWD="${MARIADB_ROOT_PASSWORD:?MARIADB_ROOT_PASSWORD not set}"
OUT=/output/profiling
mkdir -p "$OUT"
pattern="${1:-*}"

shopt -s nullglob
files=(/sql/profiling/${pattern}.sql)
[[ ${#files[@]} -gt 0 ]] || { echo "No profiling file matches: $pattern"; exit 1; }

for f in "${files[@]}"; do
  name=$(basename "$f" .sql)
  echo "Running $name ..."
  mariadb -uroot --batch < "$f" > "$OUT/$name.tsv"
  rows=$(( $(wc -l < "$OUT/$name.tsv") - 1 ))
  echo "  -> data/processed/profiling/$name.tsv ($rows rows)"
done
echo "Done."
