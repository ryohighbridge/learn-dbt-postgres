-- サンプルファクトテーブル：ステージングデータのフィルタリング
{{ config(materialized='view') }}

with staging_data as (

    select * from {{ ref('stg_example__source_data') }}

),

final as (

    select id
    from staging_data
    where id = 1

)

select * from final
