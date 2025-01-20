WITH trips_2013 AS (
    SELECT DISTINCT "start_station_id" AS "station_id"
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
    WHERE EXTRACT(year FROM TO_TIMESTAMP("start_time"/1e6)) = 2013
    
    UNION
    
    SELECT DISTINCT TRY_TO_NUMBER("end_station_id") AS "station_id"
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
    WHERE EXTRACT(year FROM TO_TIMESTAMP("start_time"/1e6)) = 2013
    AND TRY_TO_NUMBER("end_station_id") IS NOT NULL
),
trips_2014 AS (
    SELECT DISTINCT "start_station_id" AS "station_id"
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
    WHERE EXTRACT(year FROM TO_TIMESTAMP("start_time"/1e6)) = 2014
    
    UNION
    
    SELECT DISTINCT TRY_TO_NUMBER("end_station_id") AS "station_id"
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
    WHERE EXTRACT(year FROM TO_TIMESTAMP("start_time"/1e6)) = 2014
    AND TRY_TO_NUMBER("end_station_id") IS NOT NULL
),
stations_2013 AS (
    SELECT t."station_id", s."status"
    FROM trips_2013 t
    JOIN AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS s ON t."station_id" = s."station_id"
),
stations_2014 AS (
    SELECT t."station_id", s."status"
    FROM trips_2014 t
    JOIN AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS s ON t."station_id" = s."station_id"
),
counts AS (
    SELECT 2013 AS "Year", INITCAP(s."status") AS "Status", COUNT(DISTINCT s."station_id") AS "Number_of_Stations"
    FROM stations_2013 s
    GROUP BY s."status"
    UNION ALL
    SELECT 2014 AS "Year", INITCAP(s."status") AS "Status", COUNT(DISTINCT s."station_id") AS "Number_of_Stations"
    FROM stations_2014 s
    GROUP BY s."status"
)
SELECT "Year", "Status", "Number_of_Stations"
FROM counts
ORDER BY "Year", "Status";