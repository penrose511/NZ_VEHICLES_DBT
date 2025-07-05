{{ config(materialized='table') }}

with engine_perf as (
    select distinct
        cc_rating,
        engine_number,
        power_rating,
        fc_combined,
        fc_urban,
        fc_extra_urban,
        synthetic_greenhouse_gas
    from {{ ref('stg_vehicleyear') }}
    where cc_rating is not null
),

dim_engine_performance as (
    select
        row_number() over (order by cc_rating) as engine_perf_key,
        cc_rating,
        engine_number,
        power_rating,
        fc_combined,
        fc_urban,
        fc_extra_urban,
        synthetic_greenhouse_gas,
        current_date as load_date,
        'stg_vehicleyear' as record_source
    from engine_perf
)

select * from dim_engine_performance
