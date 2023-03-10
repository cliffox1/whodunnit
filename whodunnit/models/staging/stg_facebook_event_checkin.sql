{{ config(materialized='table') }}

with source_data as (

    select * 
    , now () as etl_date
    from {{ source('public', 'facebook_event_checkin') }}

)

select
    person_id,
    cast(event_id as text) as event_id,
    event_name,
    cast(date as text) as event_date,
    etl_date
from source_data

{{
config({
    "post-hook": [
      "{{ index(this, 'person_id')}}",
    ],
    })
}}