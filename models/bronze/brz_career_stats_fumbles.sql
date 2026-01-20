{{ config(
    alias='career_stats_fumbles'
) }}

select *
from {{ source('nfl', 'career_stats_fumbles') }}