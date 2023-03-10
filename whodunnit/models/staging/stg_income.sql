{{ config(materialized='table') }}

with source_data as (

    select *
    , now() as etl_date 
    from {{ source('public', 'income') }}

)

select *
from source_data

{{
config({
    "post-hook": [
      "{{ index(this, 'ssn')}}",
    ],
    })
}}