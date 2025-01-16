SELECT DATE(TO_TIMESTAMP_NTZ("start_time" / 1e6)) AS "Date", COUNT(*) AS "number_of_rides"
FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
WHERE
    LOWER("bike_type") = 'electric'
    AND "duration_minutes" > 10
    AND LOWER("subscriber_type") LIKE '%student membership%'
    AND LOWER(COALESCE("start_station_name", '')) NOT LIKE '%mobile station%'
    AND LOWER(COALESCE("start_station_name", '')) NOT LIKE '%repair shop%'
    AND LOWER(COALESCE("end_station_name", '')) NOT LIKE '%mobile station%'
    AND LOWER(COALESCE("end_station_name", '')) NOT LIKE '%repair shop%'
GROUP BY 1
ORDER BY "number_of_rides" DESC NULLS LAST
LIMIT 1;