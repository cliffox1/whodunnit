with import_get_fit_now_member as (
    select * from {{ ref('stg_get_fit_now_member') }}
),

import_get_fit_now_check_in as (
    select * from {{ ref('stg_get_fit_now_check_in') }}
)

select
    a.*,
    array_agg(
        array[
            b.check_in_timestamp,
            b.check_out_timestamp
        ]
    ) as check_in_out_period
from import_get_fit_now_member a
left join
    import_get_fit_now_check_in b on
        a.membership_id = b.membership_id
group by 1, 2, 3, 4, 5, 6
