-- grain: one row per production batch per tenant; soft-deleted batches excluded
with batches as (
    select * from {{ ref('stg_erp__productions') }}
    where not is_deleted
),

outputs as (
    select production_key, count(*) as output_products, sum(quantity) as output_units
    from {{ ref('stg_erp__production_outputs') }}
    group by production_key
),

inputs as (
    select production_key, sum(quantity) as material_units, sum(total_cost) as material_cost
    from {{ ref('stg_erp__production_inputs') }}
    group by production_key
),

wastes as (
    select production_key, sum(waste_quantity) as waste_units
    from {{ ref('stg_erp__production_wastes') }}
    group by production_key
)

select
    b.production_key,
    b.tenant_id,
    b.production_ref,
    b.batch_code,
    b.production_date,
    b.production_module_key,
    m.module_name,
    b.warehouse_key,
    b.shift_key,
    s.shift_name,
    b.production_status,
    coalesce(o.output_products, 0)              as output_products,
    coalesce(o.output_units, b.main_product_quantity, 0) as output_units,
    coalesce(i.material_units, 0)               as material_units,
    coalesce(i.material_cost, 0)                as material_cost,
    coalesce(w.waste_units, 0)                  as waste_units,
    case when coalesce(o.output_units, b.main_product_quantity, 0) > 0
         then round(coalesce(i.material_cost, 0) / coalesce(o.output_units, b.main_product_quantity), 4)
    end                                         as material_cost_per_unit,
    case when coalesce(i.material_units, 0) > 0
         then round(coalesce(w.waste_units, 0) / i.material_units, 4)
    end                                         as waste_rate
from batches as b
left join outputs as o on o.production_key = b.production_key
left join inputs  as i on i.production_key = b.production_key
left join wastes  as w on w.production_key = b.production_key
left join {{ ref('stg_erp__production_modules') }} as m on m.production_module_key = b.production_module_key
left join {{ ref('stg_erp__shifts') }}             as s on s.shift_key = b.shift_key
