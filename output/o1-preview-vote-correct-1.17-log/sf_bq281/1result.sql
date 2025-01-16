SELECT MAX("num_rides") AS "highest_number_of_rides"
FROM (
  SELECT DATE(TO_TIMESTAMP("start_time" / 1000000)) AS "ride_date",
         COUNT(*) AS "num_rides"
  FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
  WHERE LOWER(TRIM("subscriber_type")) ILIKE '%student membership%'
    AND LOWER("bike_type") = 'electric'
    AND "duration_minutes" > 10
    AND COALESCE("start_station_name", '') NOT ILIKE '%mobile station%'
    AND COALESCE("start_station_name", '') NOT ILIKE '%repair shop%'
    AND COALESCE("end_station_name", '') NOT ILIKE '%mobile station%'
    AND COALESCE("end_station_name", '') NOT ILIKE '%repair shop%'
  GROUP BY DATE(TO_TIMESTAMP("start_time" / 1000000))
) AS daily_counts;