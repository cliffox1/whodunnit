{{ config(materialized='table') }}

with source_data as (

    select * from {{ source('public', 'drivers_license') }}

)

select
    id as license_id,
    age,
    height,
    eye_color,
    hair_color,
    gender,
    plate_number,
    car_make,
    car_model
from source_data
