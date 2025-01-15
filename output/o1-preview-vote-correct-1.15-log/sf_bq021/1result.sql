WITH bike_trips_2016 AS (
  SELECT
    "start_station_id",
    "end_station_id",
    "start_station_name",
    "start_station_latitude",
    "start_station_longitude",
    "end_station_name",
    "end_station_latitude",
    "end_station_longitude",
    TO_TIMESTAMP_NTZ(
      CASE 
        WHEN "starttime" >= 1e15 THEN "starttime" / 1000000
        WHEN "starttime" >= 1e12 THEN "starttime" / 1000
        ELSE "starttime"
      END) AS start_ts,
    "tripduration"
  FROM "NEW_YORK"."NEW_YORK"."CITIBIKE_TRIPS"
  WHERE YEAR(TO_TIMESTAMP_NTZ(
      CASE 
        WHEN "starttime" >= 1e15 THEN "starttime" / 1000000
        WHEN "starttime" >= 1e12 THEN "starttime" / 1000
        ELSE "starttime"
      END)) = 2016
),
top_bike_routes AS (
  SELECT 
    "start_station_id",
    "end_station_id",
    "start_station_name",
    "start_station_latitude",
    "start_station_longitude",
    "end_station_name",
    "end_station_latitude",
    "end_station_longitude",
    COUNT(*) AS trip_count,
    AVG("tripduration") AS avg_bike_duration
  FROM bike_trips_2016
  GROUP BY 
    "start_station_id",
    "end_station_id",
    "start_station_name",
    "start_station_latitude",
    "start_station_longitude",
    "end_station_name",
    "end_station_latitude",
    "end_station_longitude"
  ORDER BY trip_count DESC
  LIMIT 20
),
taxi_trips_2016 AS (
  SELECT
    TO_TIMESTAMP_NTZ(
      CASE
        WHEN "pickup_datetime" >= 1e15 THEN "pickup_datetime" / 1000000
        WHEN "pickup_datetime" >= 1e12 THEN "pickup_datetime" / 1000
        ELSE "pickup_datetime"
      END) AS pickup_ts,
    TO_TIMESTAMP_NTZ(
      CASE
        WHEN "dropoff_datetime" >= 1e15 THEN "dropoff_datetime" / 1000000
        WHEN "dropoff_datetime" >= 1e12 THEN "dropoff_datetime" / 1000
        ELSE "dropoff_datetime"
      END) AS dropoff_ts,
    DATEDIFF('second', pickup_ts, dropoff_ts) AS tripduration,
    ROUND("pickup_latitude", 3) AS pickup_latitude_rounded,
    ROUND("pickup_longitude", 3) AS pickup_longitude_rounded,
    ROUND("dropoff_latitude", 3) AS dropoff_latitude_rounded,
    ROUND("dropoff_longitude", 3) AS dropoff_longitude_rounded
  FROM "NEW_YORK"."NEW_YORK"."TLC_YELLOW_TRIPS_2016"
  WHERE YEAR(
    TO_TIMESTAMP_NTZ(
      CASE
        WHEN "pickup_datetime" >= 1e15 THEN "pickup_datetime" / 1000000
        WHEN "pickup_datetime" >= 1e12 THEN "pickup_datetime" / 1000
        ELSE "pickup_datetime"
      END)) = 2016
    AND DATEDIFF('second', pickup_ts, dropoff_ts) > 0
),
taxi_trips_with_route AS (
  SELECT
    t.*,
    b."start_station_id",
    b."end_station_id",
    b."start_station_name",
    b."start_station_latitude",
    b."start_station_longitude",
    b."end_station_name",
    b."end_station_latitude",
    b."end_station_longitude",
    b.trip_count,
    b.avg_bike_duration
  FROM taxi_trips_2016 t
  INNER JOIN top_bike_routes b
    ON t.pickup_latitude_rounded = ROUND(b."start_station_latitude", 3)
    AND t.pickup_longitude_rounded = ROUND(b."start_station_longitude", 3)
    AND t.dropoff_latitude_rounded = ROUND(b."end_station_latitude", 3)
    AND t.dropoff_longitude_rounded = ROUND(b."end_station_longitude", 3)
),
taxi_avg_durations AS (
  SELECT
    "start_station_id",
    "end_station_id",
    AVG(tripduration) AS avg_taxi_duration
  FROM taxi_trips_with_route
  GROUP BY "start_station_id", "end_station_id"
),
routes_with_taxi_info AS (
  SELECT
    b.*,
    td.avg_taxi_duration
  FROM top_bike_routes b
  LEFT JOIN taxi_avg_durations td
    ON b."start_station_id" = td."start_station_id"
    AND b."end_station_id" = td."end_station_id"
),
faster_bike_routes AS (
  SELECT *
  FROM routes_with_taxi_info
  WHERE avg_taxi_duration IS NOT NULL
    AND avg_bike_duration < avg_taxi_duration
)
SELECT
  "start_station_name",
  ROUND("start_station_latitude", 4) AS start_station_latitude,
  ROUND("start_station_longitude", 4) AS start_station_longitude
FROM faster_bike_routes
ORDER BY avg_bike_duration DESC NULLS LAST
LIMIT 1;