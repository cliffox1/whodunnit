{{ config(materialized='table') }}

with source_data as (

    select * from {{ source('public', 'get_fit_now_member') }}

)

select
    id as membership_id,
    person_id,
    name,
    membership_status,
    date(
        substring(
            cast(membership_start_date as text), 1, 4
        ) || '-' || substring(
            cast(membership_start_date as text), 5, 2
        ) || '-' || substring(cast(membership_start_date as text), 7, 2)
    ) as membership_start_date
from source_data
