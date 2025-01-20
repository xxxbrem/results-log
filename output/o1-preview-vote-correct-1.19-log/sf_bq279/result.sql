WITH trips_by_year AS (
    SELECT
        TRY_TO_NUMBER("start_station_id") AS station_id,
        YEAR(TO_TIMESTAMP("start_time" / 1000000)) AS year
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
    WHERE "start_station_id" IS NOT NULL
        AND YEAR(TO_TIMESTAMP("start_time" / 1000000)) IN (2013, 2014)

    UNION ALL

    SELECT
        TRY_TO_NUMBER("end_station_id") AS station_id,
        YEAR(TO_TIMESTAMP("start_time" / 1000000)) AS year
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
    WHERE "end_station_id" IS NOT NULL
        AND YEAR(TO_TIMESTAMP("start_time" / 1000000)) IN (2013, 2014)
),
stations_with_status AS (
    SELECT
        "station_id",
        UPPER("status") AS "status"
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS
)
SELECT
    t.year AS "Year",
    s."status" AS "Status",
    COUNT(DISTINCT t.station_id) AS "Number_of_Stations"
FROM trips_by_year t
INNER JOIN stations_with_status s ON t.station_id = s."station_id"
GROUP BY t.year, s."status"
ORDER BY t.year, s."status";