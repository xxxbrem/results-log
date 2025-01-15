WITH top_bike_routes AS (
  SELECT
    "start_station_name",
    "end_station_name",
    ROUND("start_station_latitude", 3) AS "start_lat",
    ROUND("start_station_longitude", 3) AS "start_lon",
    ROUND("end_station_latitude", 3) AS "end_lat",
    ROUND("end_station_longitude", 3) AS "end_lon",
    COUNT(*) AS "trip_count",
    AVG("tripduration") AS "avg_bike_duration"
  FROM "NEW_YORK"."NEW_YORK"."CITIBIKE_TRIPS"
  WHERE
    TO_TIMESTAMP_NTZ("starttime" / 1e6) BETWEEN '2016-01-01 00:00:00' AND '2016-12-31 23:59:59' AND
    "start_station_latitude" IS NOT NULL AND "start_station_longitude" IS NOT NULL AND
    "end_station_latitude" IS NOT NULL AND "end_station_longitude" IS NOT NULL AND
    "start_station_latitude" != 0 AND "start_station_longitude" != 0 AND
    "end_station_latitude" != 0 AND "end_station_longitude" != 0 AND
    "tripduration" IS NOT NULL AND
    "start_station_name" IS NOT NULL AND "end_station_name" IS NOT NULL
  GROUP BY "start_station_name", "end_station_name", "start_lat", "start_lon", "end_lat", "end_lon"
  ORDER BY "trip_count" DESC NULLS LAST
  LIMIT 20
),
taxi_trips_matching AS (
  SELECT
    ROUND("pickup_latitude", 3) AS "pickup_lat",
    ROUND("pickup_longitude", 3) AS "pickup_lon",
    ROUND("dropoff_latitude", 3) AS "dropoff_lat",
    ROUND("dropoff_longitude", 3) AS "dropoff_lon",
    AVG( ("dropoff_datetime" - "pickup_datetime") / 1e6 ) AS "avg_taxi_duration"
  FROM "NEW_YORK"."NEW_YORK"."TLC_YELLOW_TRIPS_2016"
  WHERE
    TO_TIMESTAMP_NTZ("pickup_datetime" / 1e6) BETWEEN '2016-01-01 00:00:00' AND '2016-12-31 23:59:59' AND
    "pickup_latitude" IS NOT NULL AND "pickup_longitude" IS NOT NULL AND
    "dropoff_latitude" IS NOT NULL AND "dropoff_longitude" IS NOT NULL AND
    "pickup_latitude" != 0 AND "pickup_longitude" != 0 AND
    "dropoff_latitude" != 0 AND "dropoff_longitude" != 0 AND
    ("dropoff_datetime" > "pickup_datetime") AND
    ("dropoff_datetime" - "pickup_datetime") / 1e6 <= 86400
  GROUP BY "pickup_lat", "pickup_lon", "dropoff_lat", "dropoff_lon"
)
SELECT
  bike."start_station_name"
FROM top_bike_routes AS bike
JOIN taxi_trips_matching AS taxi
  ON bike."start_lat" = taxi."pickup_lat" AND bike."start_lon" = taxi."pickup_lon"
     AND bike."end_lat" = taxi."dropoff_lat" AND bike."end_lon" = taxi."dropoff_lon"
WHERE
  bike."avg_bike_duration" < taxi."avg_taxi_duration"
ORDER BY bike."avg_bike_duration" DESC NULLS LAST
LIMIT 1;