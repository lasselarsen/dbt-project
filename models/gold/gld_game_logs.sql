{{ config(
    alias='game_logs',
    materialized='table'
) }}

SELECT 
    player_id
    , position
    , game_date
    , game_played
    , game_started
    , season
    , home_away
    , opponent
    , outcome
    , log_name
    , log_value
FROM {{ ref("slv_game_logs") }}
UNPIVOT(
    log_value FOR log_name IN (
    team_point_scored
    , team_point_conceded
    , passes_attempted
    , passes_completed
    , passing_yards
    , passing_tds
    , passes_ints
    , sacks
    , sacked_yards_lost
    , passer_rating
    , rushing_attempts
    , rushing_yards
    , rushing_tds
    , longest_run
    , fumbles
    , fumbles_lost
    , receptions
    , receiving_yards
    , receiving_tds
    , longest_reception
    )
)