{{ config(materialized='table') }}

with usage_data as (
    select distinct
        vehicle_usage,
        vehicle_type,
        road_transport_code,
        import_status,
        transmission_type,
        motive_power,
        alternative_motive_power,
        original_country,
        previous_country
    from {{ ref('stg_vehicleyear') }}
    where vehicle_usage is not null
),

dim_vehicle_usage as (
    select
        row_number() over (order by vehicle_usage) as vehicle_usage_key,
        vehicle_usage,
        vehicle_type,
        road_transport_code,
        import_status,
        transmission_type,
        motive_power,
        alternative_motive_power,
        original_country,
        previous_country,
        current_date as load_date,
        'stg_vehicleyear' as record_source
    from usage_data
)

select * from dim_vehicle_usage
