with person as (
    select *
    from {{ ref('person') }}
),

driver as (
    select *
    from {{ ref('drivers_license') }}
),

income as (
    select *
    from {{ ref('income') }}
),

digitalpresence as (
    select *
    from {{ ref('facebook_event_checkin') }}
),

interview as (
    select *
    from {{ ref('interview') }}
),

profile_sub as (
    select
    person.person_id
    , person.person_name
    , person.license_id
    , person.address_number
    , person.address_street_name
    , person.ssn
    , driver.age
    , driver.height
    , driver.eye_color
    , driver.hair_color
    , driver.gender
    , driver.plate_number
    , driver.car_make
    , driver.car_model
    , income.annual_income
    from person
    left join driver on person.license_id = driver.license_id
    left join income on person.ssn = income.ssn
)

select
    profile_sub.person_id,
    profile_sub.person_name,
    profile_sub.license_id,
    profile_sub.address_number,
    profile_sub.address_street_name,
    profile_sub.ssn,
    profile_sub.age,
    profile_sub.height,
    profile_sub.eye_color,
    profile_sub.hair_color,
    profile_sub.gender,
    profile_sub.plate_number,
    profile_sub.car_make,
    profile_sub.car_model,
    profile_sub.annual_income,
    array_agg(
        array[
            digitalpresence.event_date,
            digitalpresence.event_id,
            digitalpresence.event_name
        ]
    ) as digitalpresence_event,
    array_agg(array[interview.transcript]) as testimony_transcript
from profile_sub
left join digitalpresence on profile_sub.person_id = digitalpresence.person_id
left join interview on profile_sub.person_id = interview.person_id
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
