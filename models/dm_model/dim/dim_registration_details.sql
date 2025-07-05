{{ config(materialized='table') }}

with registration_data as (
    select distinct
        vin11,
        import_status,
        nz_assembled,
        original_country,
        previous_country,
        first_nz_registration_year,
        first_nz_registration_month
    from {{ ref('stg_vehicleyear') }}
    where vin11 is not null
),

dim_registration_details as (
    select
        row_number() over (order by vin11) as registration_key,
        vin11,
        import_status,
        nz_assembled,
        original_country,
        previous_country,
        first_nz_registration_year,
        first_nz_registration_month,
        current_date as load_date,
        'stg_vehicleyear' as record_source
    from registration_data
)

select * from dim_registration_details
