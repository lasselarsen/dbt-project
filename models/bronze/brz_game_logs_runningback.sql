{{ config(
    alias='game_logs_runningback'
) }}

select *
from {{ source('nfl', 'game_logs_runningback') }}