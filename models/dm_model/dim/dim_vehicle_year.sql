{{ config(materialized='table') }}

with distinct_years as (
    select distinct
        vehicle_year,
        first_nz_registration_year,
        first_nz_registration_month
    from {{ ref('stg_vehicleyear') }}
    where vehicle_year is not null
),

dim_vehicle_year as (
    select
        row_number() over (order by vehicle_year) as vehicle_year_key,
        vehicle_year,
        first_nz_registration_year,
        first_nz_registration_month,
        current_date as load_date,
        'stg_vehicleyear' as record_source
    from distinct_years
)

select * from dim_vehicle_year
