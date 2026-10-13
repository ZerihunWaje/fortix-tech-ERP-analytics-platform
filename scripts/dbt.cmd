@echo off
rem Loads .env into this shell, then runs dbt against the project in .\dbt
rem Usage (from the project root):  scripts\dbt.cmd debug | build | run | test | docs generate
setlocal
for /f "usebackq eol=# tokens=1,* delims==" %%A in (".env") do set "%%A=%%B"
dbt %* --project-dir dbt --profiles-dir dbt
endlocal
