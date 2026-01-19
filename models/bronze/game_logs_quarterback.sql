select *
from {{ source('nfl', 'game_logs_quarterback') }}