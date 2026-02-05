-- ソースデータからの基本的な抽出とクリーニング
{{ config(materialized='view') }}

with source_data as (

    select 1 as id
    union all
    select null as id

),

cleaned as (

    select id
    from source_data
    where id is not null

)

select * from cleaned
