{{ config(materialized='table') }}

with source_data as (

    select * from {{ source('public', 'get_fit_now_check_in') }}

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


        case when length(cast(check_out_time as text)) = 1
            then cast(check_out_time as text) || '00'
            when length(cast(check_out_time as text)) = 2
                then cast(check_out_time as text) || '0'
            else cast(check_out_time as text)
        end as check_out
    from source_data
),

source_clean as (
    select
        membership_id,
        check_in_date,
        check_in,
        check_out
        ,
        cast(case when length(check_in) = 4 then substring(check_in, 3, 2)
            when length(check_in) = 3 then substring(check_in, 2, 2)
            end as integer) as checkin_minutes
        ,
        cast(
            case when
                cast(
                    case
                        when length(check_in) = 4 then substring(check_in, 3, 2)
                        when length(check_in) = 3 then substring(check_in, 2, 2)
                    end as integer
                ) > 59 then
                cast(cast(
                    case
                        when length(check_in) = 4 then substring(check_in, 1, 2)
                        when
                            length(
                                check_in
                            ) = 3 then '0' || substring(check_in, 1, 1)
                    end as integer
                ) + 1 as text
                )
                else
                    (
                        case
                            when
                                length(
                                    check_in
                                ) = 4 then substring(check_in, 1, 2)
                            when
                                length(
                                    check_in
                                ) = 3 then '0' || substring(check_in, 1, 1)
                        end) end


            || ':' || case when
                cast(
                    case
                        when length(check_in) = 4 then substring(check_in, 3, 2)
                        when length(check_in) = 3 then substring(check_in, 2, 2)
                    end as integer
                ) > 59 then cast(
                    cast(
                        case
                            when
                                length(
                                    check_in
                                ) = 4 then substring(check_in, 3, 2)
                            when
                                length(
                                    check_in
                                ) = 3 then substring(check_in, 2, 2)
                        end as integer) - 60
                    as text
                )
                else
                    (
                        case
                            when
                                length(
                                    check_in
                                ) = 4 then substring(check_in, 3, 2)
                            when
                                length(
                                    check_in
                                ) = 3 then substring(check_in, 2, 2)
                        end) end as time) as checkin_minutes_1,




        cast(
            case when
                cast(
                    case
                        when
                            length(
                                check_out
                            ) = 4 then substring(check_out, 3, 2)
                        when
                            length(
                                check_out
                            ) = 3 then substring(check_out, 2, 2)
                    end as integer
                ) > 59 then
                cast(cast(
                    case
                        when
                            length(
                                check_out
                            ) = 4 then substring(check_out, 1, 2)
                        when
                            length(
                                check_out
                            ) = 3 then '0' || substring(check_out, 1, 1)
                    end as integer
                ) + 1 as text
                )
                else
                    (
                        case
                            when
                                length(
                                    check_out
                                ) = 4 then substring(check_out, 1, 2)
                            when
                                length(
                                    check_out
                                ) = 3 then '0' || substring(check_out, 1, 1)
                        end) end || ':'

            || case when
                cast(
                    case
                        when
                            length(
                                check_out
                            ) = 4 then substring(check_out, 3, 2)
                        when
                            length(
                                check_out
                            ) = 3 then substring(check_out, 2, 2)
                    end as integer
                ) > 59 then cast(
                    cast(
                        case
                            when
                                length(
                                    check_out
                                ) = 4 then substring(check_out, 3, 2)
                            when
                                length(
                                    check_out
                                ) = 3 then substring(check_out, 2, 2)
                        end as integer
                    ) - 60 as text)
                else
                    (
                        case
                            when
                                length(
                                    check_out
                                ) = 4 then substring(check_out, 3, 2)
                            when
                                length(
                                    check_out
                                ) = 3 then substring(check_out, 2, 2)
                        end) end as time)
        as checkout_minutes_1,

        case when length(check_out) = 4 then substring(check_out, 3, 2)
            when length(check_out) = 3 then substring(check_out, 2, 2)
        end
        as checkout_minutes





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
