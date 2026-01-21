{{ config(
    alias='career_stats',
    materialized='table'
) }}

SELECT 
    player_id
    , position
    , year
    , team
    , type
    , stat_name
    , stat_value
FROM {{ ref("slv_career_stats") }}
UNPIVOT(
    stat_value FOR stat_name IN (
    games_played
    , passes_attempted
    , passes_completed
    , passing_yards                 AS yards
    , passing_tds                   AS tds
    , passes_ints                   AS ints
    , longest_pass                  AS longest
    , passes_longer_than_20_yards   AS more_than_20_yards
    , passes_longer_than_40_yards   AS more_than_40_yards
    , sacks
    , sacked_yards_lost
    , passer_rating
    , rushing_attempts
    , rushing_yards                 AS yards
    , rushing_tds                   AS tds
    , longest_run                   AS longest
    , rushing_first_downs
    , rushing_more_than_20_yards    AS more_than_20_yards
    , rushing_more_than_40_yards    AS more_than_40_yards
    , fumbles
    )
)