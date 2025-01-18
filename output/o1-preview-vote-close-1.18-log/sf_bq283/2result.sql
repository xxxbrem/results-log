SELECT
    t."start_station_id" AS "station_id",
    COUNT(*) AS "total_trips",
    ROUND(COUNT(*) * 100.0 / total.total_active_trips, 4) AS "percentage_of_total_trips",
    ROUND(AVG(t."duration_minutes"), 4) AS "average_trip_duration"
FROM
    AUSTIN.AUSTIN_BIKESHARE."BIKESHARE_TRIPS" t
JOIN
    AUSTIN.AUSTIN_BIKESHARE."BIKESHARE_STATIONS" s
    ON t."start_station_id" = s."station_id"
CROSS JOIN
    (
      SELECT COUNT(*) AS total_active_trips
      FROM AUSTIN.AUSTIN_BIKESHARE."BIKESHARE_TRIPS" t2
      JOIN AUSTIN.AUSTIN_BIKESHARE."BIKESHARE_STATIONS" s2
        ON t2."start_station_id" = s2."station_id"
      WHERE s2."status" = 'active'
    ) total
WHERE
    s."status" = 'active'
GROUP BY
    t."start_station_id", total.total_active_trips
ORDER BY
    "total_trips" DESC NULLS LAST
LIMIT 15;