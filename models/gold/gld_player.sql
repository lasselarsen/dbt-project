{{ config(
    alias='player',
    materialized='table'
) }}

SELECT
        player_id
        , TRIM(SPLIT_PART(name, ',', 2) || ' ' || SPLIT_PART(name, ',', 1))     AS full_name
        , birthday
        , age
        , birth_place
        , CASE 
            WHEN REGEXP_LIKE(TRIM(REGEXP_SUBSTR(birth_place, '[^,]+$')),'^[A-Za-z]{2}')
            THEN UPPER(TRIM(REGEXP_SUBSTR(birth_place, '[^,]+$')))
            ELSE 'International'
            END                                                                 AS birth_place_state
        , current_status
        , current_team
        , height_inches
        , ROUND(height_inches * 2.54,0) as height_cm
        , weight_lbs
        , ROUND(weight_lbs * 0.45359237,0) AS weight_kg
        , college
        , high_school
        , high_school_location
        , position
        , number
        , ROUND(CASE WHEN years_played IS NOT NULL
            THEN TRIM(SPLIT_PART(years_played, '-', 1))
            WHEN experience = 'Rookie'
            THEN YEAR(current_date())
            ELSE YEAR(current_date()) - CAST(NULLIF(REGEXP_REPLACE(experience, '[^0-9]', ''), '') AS INT)
            END,0)                                                                 AS start_year
        , CASE WHEN years_played IS NOT NULL
            THEN CAST(TRIM(SPLIT_PART(years_played, '-', 2)) AS INT)
            ELSE NULL
            END                                                                 AS end_year
        , CASE WHEN experience = 'Rookie' OR experience LIKE '%0%'
            THEN 'Rookie'
            ELSE CONCAT(NULLIF(REGEXP_REPLACE(experience, '[^0-9]', ''), ''), ' seasons')
            END AS experience
FROM {{ ref('brz_basic_stats') }}