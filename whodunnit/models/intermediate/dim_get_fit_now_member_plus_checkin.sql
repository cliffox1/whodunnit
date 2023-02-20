with get_fit_now_member as (
    select * from {{ ref('get_fit_now_member') }}
),

get_fit_now_check_in as (
    select * from {{ ref('get_fit_now_check_in') }}
)

select
    get_fit_now_member.*,
    array_agg(
        array[
            get_fit_now_check_in.check_in_timestamp,
            get_fit_now_check_in.check_out_timestamp
        ]
    ) as check_in_out_period
from get_fit_now_member
left join
    get_fit_now_check_in on
        get_fit_now_member.membership_id = get_fit_now_check_in.membership_id
group by 1, 2, 3, 4, 5
