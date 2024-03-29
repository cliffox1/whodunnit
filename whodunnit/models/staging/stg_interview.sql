{{ config(materialized='table') }}

with source_data as (

    select
        *,
        now() as etl_date
    from {{ source('public', 'interview') }}

)

select *
from source_data
