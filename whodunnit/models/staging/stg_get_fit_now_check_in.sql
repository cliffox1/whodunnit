{{ config(materialized='table') }}

with source_data as (

    select * 
    , now() as etl_date
    from {{ source('public', 'get_fit_now_check_in') }}

),

source_scrub as (
    select
        membership_id,
        date(
            substring(
                cast(check_in_date as text), 1, 4
            ) || '-' || substring(
                cast(check_in_date as text), 5, 2
            ) || '-' || substring(cast(check_in_date as text), 7, 2)
        ) as check_in_date,

        case when length(cast(check_in_time as text)) = 1
            then cast(check_in_time as text) || '00'
            when length(cast(check_in_time as text)) = 2
                then cast(check_in_time as text) || '0'
            else cast(check_in_time as text)
        end as check_in,

-- converting date provided in int64 to date data type.
        case when length(cast(check_out_time as text)) = 1
            then cast(check_out_time as text) || '00'
            when length(cast(check_out_time as text)) = 2
                then cast(check_out_time as text) || '0'
            else cast(check_out_time as text)
        end as check_out,
        etl_date
    from source_data
),

source_clean as (
    select
        membership_id,
        check_in_date,
        check_in,
        check_out
        ,
        cast({{ date_parts_mins('check_in') }} as integer) as checkin_minutes
        ,
-- enforing date data on the data (which appear not to be dates but just numbers) 
        cast(
            case when
                cast(
                    {{ date_parts_mins('check_in') }} as integer
                ) 
                > 59 then
                cast(cast(
                    {{ date_parts_hrs('check_in') }}
                    as integer
                ) + 1 as text
                )
                else
                    (
                     {{ date_parts_hrs('check_in') }}      
                    ) end


            || ':' || case when
                cast(
                {{ date_parts_mins('check_in') }} as integer
                ) 
                > 59 then 
                cast(cast(
                {{ date_parts_mins('check_in') }} as integer) 
                - 60 as text
                )
                else
                    (
                      {{ date_parts_mins('check_in') }}
                    ) end as time) as checkin_minutes_1,




        cast(
            case when
                cast({{ date_parts_mins('check_out') }} as integer
                ) > 59 then
                cast(cast(
                    {{ date_parts_hrs('check_out') }}
                    as integer
                ) + 1 as text
                )
                else
                    (
                     {{ date_parts_hrs('check_out') }}
                    ) end || ':'

            || case when
                cast({{ date_parts_mins('check_out') }} as integer
                ) > 59 then 
                cast(cast(
                    {{ date_parts_mins('check_out') }} as integer
                    ) - 60 as text)
                else
                    (
                     {{ date_parts_mins('check_out') }}
                    ) end as time) as checkout_minutes_1,

        {{ date_parts_mins('check_out') }} as checkout_minutes,
        etl_date
    from source_scrub
)

select
    *,
    to_timestamp(
        to_char(
            check_in_date, 'YYYY-MM-DD'
        ) || ' ' || to_char(checkin_minutes_1, 'HH:MI:SS'),
        'YYYY-MM-DD HH:MI:SS'
    ) as check_in_timestamp,
    to_timestamp(
        to_char(
            check_in_date, 'YYYY-MM-DD'
        ) || ' ' || to_char(checkout_minutes_1, 'HH:MI:SS'),
        'YYYY-MM-DD HH:MI:SS'
    ) as check_out_timestamp
from source_clean
