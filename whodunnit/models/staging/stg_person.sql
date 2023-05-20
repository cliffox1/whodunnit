{{ config(materialized='table') }}

with source_data as (

    select *
    , now() as etl_date 
     from {{ source('public', 'person') }}

)

select
    id as person_id,
    name as person_name,
    license_id,
    address_number,
    address_street_name,
    ssn,
    etl_date
from source_data

{{
config({
    "post-hook": [
      "{{ index(this, 'person_id') }}",
    ],
    })
}}