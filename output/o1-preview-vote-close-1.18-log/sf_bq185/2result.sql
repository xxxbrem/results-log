SELECT ROUND(AVG( ("dropoff_datetime" - "pickup_datetime") / (60 * 1000000.0) ), 4) AS "Average trip duration in minutes"
FROM NEW_YORK_PLUS.NEW_YORK_TAXI_TRIPS.TLC_YELLOW_TRIPS_2016 T
JOIN NEW_YORK_PLUS.NEW_YORK_TAXI_TRIPS.TAXI_ZONE_GEOM Z
    ON T."pickup_location_id" = Z."zone_id"
WHERE Z."borough" = 'Brooklyn'
    AND T."passenger_count" > 3
    AND T."trip_distance" >= 10
    AND T."pickup_datetime" >= DATE_PART(EPOCH_MICROSECOND, TO_TIMESTAMP('2016-02-01 00:00:00'))
    AND T."pickup_datetime" < DATE_PART(EPOCH_MICROSECOND, TO_TIMESTAMP('2016-02-08 00:00:00'))
    AND ("dropoff_datetime" - "pickup_datetime") > 0;