{{ config(
    alias='basic_stats'
) }}

select * from {{ source('nfl', 'basic_stats') }}