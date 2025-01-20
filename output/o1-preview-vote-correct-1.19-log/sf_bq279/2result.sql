SELECT
    t."Year",
    s."status" AS "Status",
    COUNT(DISTINCT s."station_id") AS "Number_of_Stations"
FROM
    (
        SELECT DISTINCT
            "start_station_id" AS "station_id",
            YEAR(TO_TIMESTAMP("start_time" / 1000000)) AS "Year"
        FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
        WHERE YEAR(TO_TIMESTAMP("start_time" / 1000000)) IN (2013, 2014)
    ) AS t
JOIN AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS AS s
ON t."station_id" = s."station_id"
GROUP BY t."Year", s."status"
ORDER BY t."Year", s."status";