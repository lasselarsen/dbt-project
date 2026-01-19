select *
from {{ source('nfl', 'career_stats_passing') }}