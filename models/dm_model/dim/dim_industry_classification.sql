{{ config(materialized='table') }}

with industry_codes as (
    select distinct
        industry_class,
        industry_model_code,
        mvma_model_code,
        road_transport_code,
        tla
    from {{ ref('stg_vehicleyear') }}
    where industry_class is not null
),

dim_industry_classification as (
    select
        row_number() over (order by industry_class) as industry_classification_key,
        industry_class,
        industry_model_code,
        mvma_model_code,
        road_transport_code,
        tla,
        current_date as load_date,
        'stg_vehicleyear' as record_source
    from industry_codes
)

select * from dim_industry_classification
