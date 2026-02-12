{{ config(materialized='view') }}

with source as (

    select * from {{ source('raw', 'prefectures') }}

),

renamed as (

    select
        code as prefecture_code,
        name as prefecture_name

    from source

)

select * from renamed
