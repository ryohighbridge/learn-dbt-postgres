{{ config(materialized='table') }}

with prefectures as (

    select * from {{ ref('stg_raw__prefectures') }}

),

final as (

    select
        prefecture_code,
        prefecture_name
    from prefectures

)

select * from final
