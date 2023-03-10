{{ config(materialized='table') }}

with source_data as (

    select * 
    , now () as etl_date
    from {{ source('public', 'crime_scene_report') }}

)

select *
from source_data
