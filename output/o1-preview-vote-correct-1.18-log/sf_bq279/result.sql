WITH trip_stations AS (
    SELECT DISTINCT
        "start_station_id" AS "station_id",
        YEAR(TO_TIMESTAMP_NTZ("start_time" / 1e6)) AS "Year"
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
    WHERE YEAR(TO_TIMESTAMP_NTZ("start_time" / 1e6)) IN (2013, 2014)
)
SELECT 
    ts."Year",
    bs."status",
    COUNT(DISTINCT ts."station_id") AS "Number_of_Stations"
FROM trip_stations ts
JOIN AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS bs ON ts."station_id" = bs."station_id"
GROUP BY ts."Year", bs."status"
ORDER BY ts."Year", bs."status";