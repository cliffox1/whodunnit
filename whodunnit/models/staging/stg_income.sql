{{ config(materialized='table') }}

with source_data as (

    select * from {{ source('public', 'income') }}

)

select *
from source_data
