SELECT
  TZP."zone_name" AS pickup_zone,
  TZD."zone_name" AS dropoff_zone,
  ROUND((T."dropoff_datetime" - T."pickup_datetime") / 1e6 / 60, 4) AS trip_duration_minutes,
  ROUND(T."trip_distance" / ((T."dropoff_datetime" - T."pickup_datetime") / 1e6 / 3600), 4) AS driving_speed_mph,
  ROUND(T."tip_amount" / NULLIF(T."fare_amount", 0), 4) AS tip_rate
FROM
  NEW_YORK_PLUS.NEW_YORK_TAXI_TRIPS.TLC_YELLOW_TRIPS_2016 T
  JOIN NEW_YORK_PLUS.NEW_YORK_TAXI_TRIPS.TAXI_ZONE_GEOM TZP ON T."pickup_location_id" = TZP."zone_id"
  JOIN NEW_YORK_PLUS.NEW_YORK_TAXI_TRIPS.TAXI_ZONE_GEOM TZD ON T."dropoff_location_id" = TZD."zone_id"
WHERE
  T."passenger_count" > 5
  AND T."trip_distance" >= 10
  AND T."fare_amount" > 0
  AND (T."dropoff_datetime" - T."pickup_datetime") > 0
  AND TO_TIMESTAMP(T."pickup_datetime" / 1e6) >= '2016-07-01'
  AND TO_TIMESTAMP(T."pickup_datetime" / 1e6) < '2016-07-08'
ORDER BY
  T."total_amount" DESC NULLS LAST
LIMIT 10;