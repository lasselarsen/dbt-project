{{ config(
    alias='career_stats',
    materialized='table'
) }}

WITH passing AS (

    SELECT
          player_id
        , name
        , position
        , year
        , team
        , CAST(games_played AS INT)                                                             AS games_played
        , CAST(NULLIF(REGEXP_REPLACE(passes_attempted, '[^0-9]', ''), '') AS INT)               AS passes_attempted
        , CAST(NULLIF(REGEXP_REPLACE(passes_completed, '[^0-9]', ''), '') AS INT)               AS passes_completed
        , CAST(NULLIF(REGEXP_REPLACE(passing_yards, '[^0-9]', ''), '') AS INT)                  AS passing_yards
        , CAST(NULLIF(REGEXP_REPLACE(td_passes, '[^0-9]', ''), '') AS INT)                      AS passing_tds
        , CAST(NULLIF(REGEXP_REPLACE(ints, '[^0-9]', ''), '') AS INT)                           AS passes_ints
        , CAST(NULLIF(REGEXP_REPLACE(longest_pass, '[^0-9]', ''), '') AS INT)                   AS longest_pass
        , CAST(NULLIF(REGEXP_REPLACE(passes_longer_than_20_yards, '[^0-9]', ''), '') AS INT)    AS passes_longer_than_20_yards
        , CAST(NULLIF(REGEXP_REPLACE(passes_longer_than_40_yards, '[^0-9]', ''), '') AS INT)    AS passes_longer_than_40_yards
        , CAST(NULLIF(REGEXP_REPLACE(sacks, '[^0-9]', ''), '') AS INT)                          AS sacks
        , CAST(NULLIF(REGEXP_REPLACE(sacked_yards_lost, '[^0-9]', ''), '') AS INT)              AS sacked_yards_lost
        , ROUND(CAST(passer_rating AS NUMBER(10,2)), 2)                                         AS passer_rating
    FROM {{ ref("brz_career_stats_passing") }}

), rushing AS (

    SELECT
          player_id
        , name
        , position
        , year
        , team
        , CAST(games_played AS INT)                                                         AS games_played
        , CAST(NULLIF(REGEXP_REPLACE(rushing_attempts, '[^0-9]', ''), '') AS INT)           AS rushing_attempts
        , CAST(NULLIF(REGEXP_REPLACE(rushing_yards, '[^0-9]', ''), '') AS INT)              AS rushing_yards
        , CAST(NULLIF(REGEXP_REPLACE(rushing_tds, '[^0-9]', ''), '') AS INT)                AS rushing_tds
        , CAST(NULLIF(REGEXP_REPLACE(longest_rushing_run, '[^0-9]', ''), '') AS INT)        AS longest_run
        , CAST(NULLIF(REGEXP_REPLACE(rushing_first_downs, '[^0-9]', ''), '') AS INT)        AS rushing_first_downs
        , CAST(NULLIF(REGEXP_REPLACE(rushing_more_than_20_yards, '[^0-9]', ''), '') AS INT) AS rushing_more_than_20_yards
        , CAST(NULLIF(REGEXP_REPLACE(rushing_more_than_40_yards, '[^0-9]', ''), '') AS INT) AS rushing_more_than_40_yards
        , CAST(NULLIF(REGEXP_REPLACE(fumbles, '[^0-9]', ''), '') AS INT)                    AS fumbles
    FROM {{ ref('brz_career_stats_rushing') }}

),

merged AS (

    SELECT
          COALESCE(p.player_id, r.player_id)        AS player_id
        , COALESCE(p.name, r.name)                  AS name
        , COALESCE(p.position, r.position)          AS position
        , COALESCE(p.year, r.year)                  AS year
        , COALESCE(p.team, r.team)                  AS team
        , COALESCE(p.games_played, r.games_played)  AS games_played

        -- passing
        , p.passes_attempted
        , p.passes_completed
        , p.passing_yards
        , p.passing_tds
        , p.passes_ints
        , p.longest_pass
        , p.passes_longer_than_20_yards
        , p.passes_longer_than_40_yards
        , p.sacks
        , p.sacked_yards_lost
        , p.passer_rating

        -- rushing
        , r.rushing_attempts
        , r.rushing_yards
        , r.rushing_tds
        , r.longest_run
        , r.rushing_first_downs
        , r.rushing_more_than_20_yards
        , r.rushing_more_than_40_yards
        , r.fumbles

    FROM passing p
    FULL JOIN rushing r
        ON  r.player_id = p.player_id
        AND r.position = p.position
        AND r.year = p.year
        AND r.team = p.team
)

SELECT *
FROM merged
