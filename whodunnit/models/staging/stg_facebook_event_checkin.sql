{{ config(materialized='table') }}

with source_data as (

    select * from {{ source('public', 'facebook_event_checkin') }}

)

select
    person_id,
    cast(event_id as text) as event_id,
    event_name,
    cast(date as text) as event_date
from source_data
