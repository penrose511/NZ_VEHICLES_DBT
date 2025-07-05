{{ config(materialized='table') }}

with misc_data as (
    select distinct
        submodel,
        chassis7,
        class
    from {{ ref('stg_vehicleyear') }}
    where submodel is not null
),

dim_miscellaneous as (
    select
        row_number() over (order by submodel) as misc_key,
        submodel,
        chassis7,
        class,
        current_date as load_date,
        'stg_vehicleyear' as record_source
    from misc_data
)

select * from dim_miscellaneous
