{{ config(
    alias="game_logs"
) }}

WITH quaterback AS (

    SELECT
          player_id
        , name
        , IFF(position IS NULL, 'QB', position)                                     AS position
        , year
        , TO_DATE(year || '-' || game_date, 'YYYY-MM/DD')                           AS game_date
        , season
        , home_away
        , opponent
        , outcome
        , score
        , IFF(games_played = 1, true, false)                                        AS game_played
        , IFF(games_started = '1', true, false)                                     AS game_started
        , CAST(NULLIF(REGEXP_REPLACE(passes_attempted, '[^0-9]', ''), '') AS INT)   AS passes_attempted
        , CAST(NULLIF(REGEXP_REPLACE(passes_completed, '[^0-9]', ''), '') AS INT)   AS passes_completed
        , CAST(NULLIF(REGEXP_REPLACE(passing_yards, '[^0-9]', ''), '') AS INT)      AS passing_yards
        , CAST(NULLIF(REGEXP_REPLACE(td_passes, '[^0-9]', ''), '') AS INT)          AS passing_tds
        , CAST(NULLIF(REGEXP_REPLACE(ints, '[^0-9]', ''), '') AS INT)               AS passes_ints
        , CAST(NULLIF(REGEXP_REPLACE(sacks, '[^0-9]', ''), '') AS INT)              AS sacks
        , CAST(NULLIF(REGEXP_REPLACE(sacked_yards_lost, '[^0-9]', ''), '') AS INT)  AS sacked_yards_lost
        , ROUND(CAST(passer_rating AS NUMBER(10,2)), 2)                             AS passer_rating
        , CAST(NULLIF(REGEXP_REPLACE(rushing_attempts, '[^0-9]', ''), '') AS INT)   AS rushing_attempts
        , CAST(NULLIF(REGEXP_REPLACE(rushing_yards, '[^0-9]', ''), '') AS INT)      AS rushing_yards
        , CAST(NULLIF(REGEXP_REPLACE(rushing_tds, '[^0-9]', ''), '') AS INT)        AS rushing_tds
        , CAST(NULLIF(REGEXP_REPLACE(fumbles, '[^0-9]', ''), '') AS INT)            AS fumbles
        , CAST(NULLIF(REGEXP_REPLACE(fumbles_lost, '[^0-9]', ''), '') AS INT)       AS fumbles_lost
        , NULL                                                                      AS receptions
        , NULL                                                                      AS receiving_yards
        , NULL                                                                      AS receiving_tds
        , NULL                                                                      AS longest_reception 
    FROM {{ ref("brz_game_logs_quarterback") }}

), runningback AS (
    SELECT
          player_id
        , name
        , position
        , year
        , TO_DATE(year || '-' || game_date, 'YYYY-MM/DD')                               AS game_date
        , season
        , home_away
        , opponent
        , outcome
        , score
        , IFF(games_played = 1, true, false)                                            AS game_played
        , IFF(games_started = '1', true, false)                                         AS game_started
        , NULL                                                                          AS passes_attempted
        , NULL                                                                          AS passes_completed
        , NULL                                                                          AS passing_yards
        , NULL                                                                          AS passes_ints
        , NULL                                                                          AS sacks
        , NULL                                                                          AS sacked_yards_lost
        , NULL                                                                          AS passer_rating
        , CAST(NULLIF(REGEXP_REPLACE(rushing_attempts, '[^0-9]', ''), '') AS INT)       AS rushing_attempts
        , CAST(NULLIF(REGEXP_REPLACE(rushing_yards, '[^0-9]', ''), '') AS INT)          AS rushing_yards
        , CAST(NULLIF(REGEXP_REPLACE(rushing_tds, '[^0-9]', ''), '') AS INT)            AS rushing_tds
        , CAST(NULLIF(REGEXP_REPLACE(longest_rushing_run, '[^0-9]', ''), '') AS INT)    AS longest_run
        , CAST(NULLIF(REGEXP_REPLACE(fumbles, '[^0-9]', ''), '') AS INT)                AS fumbles
        , CAST(NULLIF(REGEXP_REPLACE(fumbles_lost, '[^0-9]', ''), '') AS INT)           AS fumbles_lost
        , CAST(NULLIF(REGEXP_REPLACE(receptions, '[^0-9]', ''), '') AS INT)             AS receptions
        , CAST(NULLIF(REGEXP_REPLACE(receiving_yards, '[^0-9]', ''), '') AS INT)        AS receiving_yards
        , CAST(NULLIF(REGEXP_REPLACE(receiving_tds, '[^0-9]', ''), '') AS INT)          AS receiving_tds
        , CAST(NULLIF(REGEXP_REPLACE(longest_reception, '[^0-9]', ''), '') AS INT)      AS longest_reception 
    FROM {{ ref('brz_game_logs_runningback') }}

)

SELECT * FROM quaterback
UNION ALL
SELECT * FROM runningback
