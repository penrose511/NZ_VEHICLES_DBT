{{ config(materialized='table') }}

with weight_data as (
    select distinct
        gross_vehicle_mass,
        vdam_weight
    from {{ ref('stg_vehicleyear') }}
    where gross_vehicle_mass is not null
),

dim_weight_details as (
    select
        row_number() over (order by gross_vehicle_mass) as weight_key,
        gross_vehicle_mass,
        vdam_weight,
        current_date as load_date,
        'stg_vehicleyear' as record_source
    from weight_data
)

select * from dim_weight_details
