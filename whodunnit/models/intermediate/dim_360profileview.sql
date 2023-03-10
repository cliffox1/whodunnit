with import_public_profile as (
    select * from {{ ref('dim_profile') }}
),

import_get_fit as (
    select * from {{ ref('dim_get_fit_now_member_plus_checkin') }}
)

select
    a.person_id,
    a.person_name,
    a.license_id,
    a.address_number,
    a.address_street_name,
    a.ssn,
    a.age,
    a.height,
    a.eye_color,
    a.hair_color,
    a.gender,
    a.plate_number,
    a.car_make,
    a.car_model,
    a.annual_income,
    a.digitalpresence_event,
    a.testimony_transcript,
    b.membership_id,
    b.membership_start_date,
    b.membership_status,
    b.check_in_out_period
from import_public_profile a 
left join import_get_fit b on a.person_id = b.person_id
