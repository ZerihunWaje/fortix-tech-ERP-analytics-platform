-- grain: one row per calendar day
-- range: 1 Jan of the first year with any activity to 31 Dec of the year after the last activity
with activity as (
    select sale_date as d from {{ ref('stg_erp__sales') }}
    union all
    select purchase_date from {{ ref('stg_erp__purchases') }}
    union all
    select production_date from {{ ref('stg_erp__productions') }}
),

bounds as (
    select
        date_trunc('year', min(d))::date                                       as start_date,
        (date_trunc('year', max(d)) + interval '2 years' - interval '1 day')::date as end_date
    from activity
),

days as (
    select generate_series(start_date, end_date, interval '1 day')::date as date_day
    from bounds
)

select
    date_day,
    cast(to_char(date_day, 'YYYYMMDD') as integer)    as date_id,
    extract(year from date_day)::int                  as year,
    extract(quarter from date_day)::int               as quarter,
    'Q' || extract(quarter from date_day)::int        as quarter_label,
    extract(month from date_day)::int                 as month,
    to_char(date_day, 'Mon')                          as month_short,
    to_char(date_day, 'YYYY-MM')                      as year_month,
    date_trunc('month', date_day)::date               as month_start,
    extract(isodow from date_day)::int                as iso_weekday,
    to_char(date_day, 'Dy')                           as weekday_short,
    extract(isodow from date_day) in (6, 7)           as is_weekend,
    date_trunc('week', date_day)::date                as week_start,
    -- Ethiopian fiscal year starts on Hamle 1, which falls on 8 July (7 July in some years).
    -- Approximation: 8 July. Label uses Gregorian years, e.g. "FY 2026/27".
    case when date_day >= make_date(extract(year from date_day)::int, 7, 8)
         then 'FY ' || extract(year from date_day)::int || '/' || right((extract(year from date_day)::int + 1)::text, 2)
         else 'FY ' || (extract(year from date_day)::int - 1) || '/' || right(extract(year from date_day)::int::text, 2)
    end                                               as et_fiscal_year
from days
