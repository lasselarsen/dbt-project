{{ config(
    alias='career_stats_receiving'
) }}

select *
from {{ source('nfl', 'career_stats_receiving') }}