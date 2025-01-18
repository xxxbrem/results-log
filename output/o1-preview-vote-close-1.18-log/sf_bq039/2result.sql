SELECT
    pz."zone_name" AS "pickup_zone",
    dz."zone_name" AS "dropoff_zone",
    ROUND(((tr."dropoff_datetime" - tr."pickup_datetime") / 60000000.0), 4) AS "trip_duration_minutes",
    ROUND(((tr."trip_distance" * 3600000000.0) / (tr."dropoff_datetime" - tr."pickup_datetime")), 4) AS "driving_speed_mph",
    ROUND((tr."tip_amount" / tr."fare_amount") * 100.0, 4) AS "tip_rate_percent"
FROM
    "NEW_YORK_PLUS"."NEW_YORK_TAXI_TRIPS"."TLC_YELLOW_TRIPS_2016" tr
JOIN
    "NEW_YORK_PLUS"."NEW_YORK_TAXI_TRIPS"."TAXI_ZONE_GEOM" pz
    ON tr."pickup_location_id" = pz."zone_id"
JOIN
    "NEW_YORK_PLUS"."NEW_YORK_TAXI_TRIPS"."TAXI_ZONE_GEOM" dz
    ON tr."dropoff_location_id" = dz."zone_id"
WHERE
    tr."pickup_datetime" >= 1467331200000000  -- July 1, 2016, 00:00:00 UTC in microseconds
    AND tr."pickup_datetime" < 1467936000000000  -- July 8, 2016, 00:00:00 UTC in microseconds
    AND tr."passenger_count" > 5
    AND tr."trip_distance" >= 10
    AND tr."fare_amount" > 0
    AND (tr."dropoff_datetime" - tr."pickup_datetime") > 0
ORDER BY
    tr."total_amount" DESC NULLS LAST
LIMIT 10;