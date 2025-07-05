{{ config(materialized='table') }}

with source_data as (
    select *
    from {{ ref('stg_vehicleyear') }}
),

dim_make as (
    select
        make_key,
        make_name
    from {{ ref('dim_make') }}
),

dim_vehicle_year as (
    select
        vehicle_year_key,
        vehicle_year
    from {{ ref('dim_vehicle_year') }}
),

dim_vehicle_usage as (
    select
        vehicle_usage_key,
        vehicle_usage
    from {{ ref('dim_vehicle_usage') }}
),

dim_vehicle_physical as (
    select
        vehicle_physical_key,
        body_type,
        basic_colour
    from {{ ref('dim_vehicle_physical') }}
),

dim_registration_details as (
    select
        registration_key,
        vin11
    from {{ ref('dim_registration_details') }}
),

dim_weight_details as (
    select
        weight_key,
        gross_vehicle_mass
    from {{ ref('dim_weight_details') }}
),

dim_miscellaneous as (
    select
        misc_key,
        submodel
    from {{ ref('dim_miscellaneous') }}
)

select
    m.make_key,
    vy.vehicle_year_key,
    vu.vehicle_usage_key,
    vp.vehicle_physical_key,
    rd.registration_key,
    wd.weight_key,
    ms.misc_key,

    source.fc_combined,
    source.fc_urban,
    source.fc_extra_urban,

    current_date as load_date

from source_data source

left join dim_make m on source.make = m.make_name
left join dim_vehicle_year vy on source.vehicle_year = vy.vehicle_year
left join dim_vehicle_usage vu on source.vehicle_usage = vu.vehicle_usage
left join dim_vehicle_physical vp on source.body_type = vp.body_type and source.basic_colour = vp.basic_colour
left join dim_registration_details rd on source.vin11 = rd.vin11
left join dim_weight_details wd on source.gross_vehicle_mass = wd.gross_vehicle_mass
left join dim_miscellaneous ms on source.submodel = ms.submodel
