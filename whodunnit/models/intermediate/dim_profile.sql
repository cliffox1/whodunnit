with import_person as (
    select *
    from {{ ref('stg_person') }}
),

import_driver as (
    select *
    from {{ ref('stg_drivers_license') }}
),

import_income as (
    select *
    from {{ ref('stg_income') }}
),

import_digitalpresence as (
    select *
    from {{ ref('stg_facebook_event_checkin') }}
),

import_interview as (
    select *
    from {{ ref('stg_interview') }}
),

logical_profile_sub as (
    select
        import_person.person_id,
        import_person.person_name,
        import_person.license_id,
        import_person.address_number,
        import_person.address_street_name,
        import_person.ssn,
        import_driver.age,
        import_driver.height,
        import_driver.eye_color,
        import_driver.hair_color,
        import_driver.gender,
        import_driver.plate_number,
        import_driver.car_make,
        import_driver.car_model,
        import_income.annual_income
    from import_person
    left join import_driver on import_person.license_id = import_driver.license_id
    left join import_income on import_person.ssn = import_income.ssn
)

select
    logical_profile_sub.person_id,
    logical_profile_sub.person_name,
    logical_profile_sub.license_id,
    logical_profile_sub.address_number,
    logical_profile_sub.address_street_name,
    logical_profile_sub.ssn,
    logical_profile_sub.age,
    logical_profile_sub.height,
    logical_profile_sub.eye_color,
    logical_profile_sub.hair_color,
    logical_profile_sub.gender,
    logical_profile_sub.plate_number,
    logical_profile_sub.car_make,
    logical_profile_sub.car_model,
    logical_profile_sub.annual_income,
    array_agg(
        array[
            import_digitalpresence.event_date,
            import_digitalpresence.event_id,
            import_digitalpresence.event_name
        ]
    ) as digitalpresence_event,
    array_agg(array[import_interview.transcript]) as testimony_transcript
from logical_profile_sub
left join import_digitalpresence on logical_profile_sub.person_id = import_digitalpresence.person_id
left join import_interview on logical_profile_sub.person_id = import_interview.person_id
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
