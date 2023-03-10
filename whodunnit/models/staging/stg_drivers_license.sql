{{ config(materialized='table') }}

with source_data as (

    select * 
    , now () as etl_date
    from {{ source('public', 'drivers_license') }}

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
    car_model,
    etl_date
from source_data

{{
config({
    "post-hook": [
      "{{ index(this, 'license_id')}}",
    ],
    })
}}