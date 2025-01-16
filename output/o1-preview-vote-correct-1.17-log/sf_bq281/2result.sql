SELECT
    DATE(TO_TIMESTAMP_NTZ("start_time" / 1000000)) AS "date",
    COUNT(*) AS "number_of_rides"
FROM
    AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
WHERE
    "subscriber_type" = 'Student Membership'
    AND "bike_type" = 'electric'
    AND "duration_minutes" > 10
    AND "start_station_name" NOT LIKE '%Mobile Station%'
    AND "start_station_name" NOT LIKE '%Repair Shop%'
    AND "end_station_name" NOT LIKE '%Mobile Station%'
    AND "end_station_name" NOT LIKE '%Repair Shop%'
GROUP BY
    "date"
ORDER BY
    "number_of_rides" DESC NULLS LAST
LIMIT 1;