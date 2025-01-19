WITH all_years AS (
    SELECT 2013 AS "Year" UNION ALL SELECT 2014 AS "Year"
),
station_years AS (
    SELECT
        s."station_id",
        y."Year",
        CASE WHEN t."station_id" IS NOT NULL THEN 'Active' ELSE 'Closed' END AS "Status"
    FROM
        AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS s
    CROSS JOIN all_years y
    LEFT JOIN (
        SELECT DISTINCT
            "start_station_id" AS "station_id",
            EXTRACT(YEAR FROM TO_TIMESTAMP("start_time" / 1000000)) AS "Year"
        FROM
            AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
        WHERE
            EXTRACT(YEAR FROM TO_TIMESTAMP("start_time" / 1000000)) IN (2013, 2014)
    ) t ON s."station_id" = t."station_id" AND y."Year" = t."Year"
)
SELECT
    "Year",
    "Status",
    COUNT(DISTINCT "station_id") AS "Number_of_Stations"
FROM
    station_years
GROUP BY
    "Year", "Status"
ORDER BY
    "Year", "Status";