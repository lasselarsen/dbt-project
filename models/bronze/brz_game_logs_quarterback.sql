{{ config(
    alias='game_logs_quarterback'
) }}

select *
from {{ source('nfl', 'game_logs_quarterback') }}