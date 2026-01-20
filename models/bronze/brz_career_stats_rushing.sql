{{ config(
    alias='career_stats_rushing'
) }}

select *
from {{ source('nfl', 'career_stats_rushing') }}