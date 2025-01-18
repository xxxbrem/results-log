WITH ActiveStations AS (
    SELECT "station_id"
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS
    WHERE "status" = 'active'
)

SELECT 
    T."start_station_id" AS station_id,
    COUNT(*) AS total_trips,
    ROUND((COUNT(*)::FLOAT / (SELECT COUNT(*) FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS T_total
                              JOIN ActiveStations S_total ON T_total."start_station_id" = S_total."station_id"
                              WHERE T_total."start_station_id" IS NOT NULL 
                                AND T_total."duration_minutes" IS NOT NULL)
          ) * 100, 4) AS percentage_of_trips,
    ROUND(AVG(T."duration_minutes"), 4) AS average_duration
FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS T
JOIN ActiveStations S ON T."start_station_id" = S."station_id"
WHERE T."start_station_id" IS NOT NULL 
  AND T."duration_minutes" IS NOT NULL
GROUP BY T."start_station_id"
ORDER BY total_trips DESC NULLS LAST
LIMIT 15;