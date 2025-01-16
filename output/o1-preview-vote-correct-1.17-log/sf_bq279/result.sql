SELECT
    EXTRACT(YEAR FROM TO_TIMESTAMP_NTZ(t."start_time" / 1e6)) AS "year",
    COUNT(DISTINCT CASE WHEN s."status" = 'active' THEN t."start_station_id" END) AS "number_active",
    COUNT(DISTINCT CASE WHEN s."status" = 'closed' THEN t."start_station_id" END) AS "number_closed"
FROM
    AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS t
JOIN
    AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_STATIONS s
    ON t."start_station_id" = s."station_id"
WHERE
    EXTRACT(YEAR FROM TO_TIMESTAMP_NTZ(t."start_time" / 1e6)) IN (2013, 2014)
GROUP BY
    "year"
ORDER BY
    "year";