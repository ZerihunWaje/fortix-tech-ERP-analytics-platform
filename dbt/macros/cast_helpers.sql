{#- raw stores every value as text (see ingestion/python/load_raw.py).
    These helpers turn empty strings into NULL and cast to the right type. -#}

{% macro clean_text(col) -%}
    nullif(trim({{ col }}), '')
{%- endmacro %}

{% macro to_int(col) -%}
    cast(cast(nullif(trim({{ col }}), '') as numeric) as bigint)
{%- endmacro %}

{% macro to_num(col) -%}
    cast(nullif(trim({{ col }}), '') as numeric(18, 4))
{%- endmacro %}

{% macro to_bool(col) -%}
    case when nullif(trim({{ col }}), '') is null then null
         else cast(nullif(trim({{ col }}), '') as numeric) <> 0 end
{%- endmacro %}

{% macro to_date(col) -%}
    cast(nullif(trim({{ col }}), '') as date)
{%- endmacro %}

{% macro to_ts(col) -%}
    cast(nullif(trim({{ col }}), '') as timestamp)
{%- endmacro %}

{#- Key that is unique across tenants: ids like 1, 2, 3 repeat in every customer DB. -#}
{% macro tenant_key(id_col, tenant_col='tenant_id') -%}
    case when nullif(trim({{ id_col }}), '') is null then null
         else {{ tenant_col }} || '-' || cast(cast(trim({{ id_col }}) as numeric) as bigint) end
{%- endmacro %}
