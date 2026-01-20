{{ config(
    alias='career_stats_passing'
) }}

select *
from {{ source('nfl', 'career_stats_passing') }}