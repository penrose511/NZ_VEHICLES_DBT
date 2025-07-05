{{ config(materialized='table') }}

with distinct_makes as (
    select distinct make
    from {{ ref('stg_vehicleyear') }}
    where make is not null
),

dim_make as (
    select
        row_number() over (order by make) as make_key,
        make as make_name,
        current_date as load_date,
        'stg_vehicleyear' as record_source
    from distinct_makes
)

select * from dim_make
