{{ config(materialized='table') }}

with source_data as (

    select * from {{ source('public', 'person') }}

)

select
    id as person_id,
    name as person_name,
    license_id,
    address_number,
    address_street_name,
    ssn

from source_data
