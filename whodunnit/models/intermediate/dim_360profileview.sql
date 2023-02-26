with public_profile as (
    select * from {{ ref('dim_profile') }}
),

get_fit as (
    select * from {{ ref('dim_get_fit_now_member_plus_checkin') }}
)

select
    public_profile.person_id,
    public_profile.person_name,
    , public_profile.license_id,
    , public_profile.address_number,
    , public_profile.address_street_name,
    , public_profile.ssn,
    , public_profile.age,
    , public_profile.height,
    , public_profile.eye_color,
    , public_profile.hair_color,
    , public_profile.gender,
    , public_profile.plate_number,
    , public_profile.car_make,
    , public_profile.car_model,
    , public_profile.annual_income,
    , public_profile.digitalpresence_event
    , public_profile.testimony_transcript
    , get_fit.membership_id
    , get_fit.membership_start_date
    , get_fit.membership_status
    , get_fit.check_in_out_period
from public_profile
left join get_fit on public_profile.person_id = get_fit.person_id
