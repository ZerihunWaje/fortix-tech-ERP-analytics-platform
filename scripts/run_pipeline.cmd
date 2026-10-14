@echo off
rem ---------------------------------------------------------------------------
rem  Runs the whole pipeline: Docker -> ingestion (raw) -> dbt build -> dbt docs
rem  Usage (from anywhere):  scripts\run_pipeline.cmd
rem  Output of every step is written to logs\pipeline_<timestamp>.log
rem ---------------------------------------------------------------------------
setlocal
cd /d "%~dp0.."

for /f %%t in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HHmm"') do set "TS=%%t"
if not exist logs mkdir logs
set "LOG=logs\pipeline_%TS%.log"

set "PY=python"
if exist ".venv\Scripts\python.exe" set "PY=.venv\Scripts\python.exe"

echo Pipeline started %TS%  (log: %LOG%)
echo.

echo [1/4] Starting Docker containers (MariaDB + Postgres)...
docker compose up -d --wait >> "%LOG%" 2>&1 || goto :fail

echo [2/4] Loading customer databases into raw...
"%PY%" ingestion\python\load_raw.py >> "%LOG%" 2>&1 || goto :fail

echo [3/4] dbt build (seed, models, tests)...
call scripts\dbt.cmd build >> "%LOG%" 2>&1 || goto :fail

echo [4/4] dbt docs generate...
call scripts\dbt.cmd docs generate >> "%LOG%" 2>&1 || goto :fail

echo.
echo Pipeline OK.  Details: %LOG%
findstr /C:"Done. PASS=" "%LOG%"
endlocal
exit /b 0

:fail
echo.
echo PIPELINE FAILED. Last lines of %LOG%:
echo ---------------------------------------------------------------
powershell -NoProfile -Command "Get-Content -Tail 25 '%LOG%'"
endlocal
exit /b 1
