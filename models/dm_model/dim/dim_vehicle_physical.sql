{{ config(materialized='table') }}

with physical_attrs as (
    select distinct
        body_type,
        basic_colour,
        number_of_axles,
        number_of_seats,
        height,
        width,
        gross_vehicle_mass,
        vdam_weight
    from {{ ref('stg_vehicleyear') }}
    where body_type is not null
),

dim_vehicle_physical as (
    select
        row_number() over (order by body_type, basic_colour) as vehicle_physical_key,
        body_type,
        basic_colour,
        number_of_axles,
        number_of_seats,
        height,
        width,
        gross_vehicle_mass,
        vdam_weight,
        current_date as load_date,
        'stg_vehicleyear' as record_source
    from physical_attrs
)

select * from dim_vehicle_physical
