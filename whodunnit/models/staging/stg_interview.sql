{{ config(materialized='table') }}

with source_data as (

    select * from {{ source('public', 'interview') }}

)

select *
from source_data
