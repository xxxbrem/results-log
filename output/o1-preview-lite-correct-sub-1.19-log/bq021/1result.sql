WITH citibike_routes AS (
  SELECT FORMAT('%.3f', ROUND(start_station_latitude, 3)) AS start_lat,
         FORMAT('%.3f', ROUND(start_station_longitude, 3)) AS start_lng,
         FORMAT('%.3f', ROUND(end_station_latitude, 3)) AS end_lat,
         FORMAT('%.3f', ROUND(end_station_longitude, 3)) AS end_lng,
         COUNT(*) AS trip_count,
         AVG(tripduration) AS avg_bike_duration_seconds
  FROM `bigquery-public-data.new_york.citibike_trips`
  WHERE EXTRACT(YEAR FROM starttime) = 2016
  GROUP BY start_lat, start_lng, end_lat, end_lng
  ORDER BY trip_count DESC
  LIMIT 20
),
taxi_routes AS (
  SELECT FORMAT('%.3f', ROUND(pickup_latitude, 3)) AS pickup_lat,
         FORMAT('%.3f', ROUND(pickup_longitude, 3)) AS pickup_lng,
         FORMAT('%.3f', ROUND(dropoff_latitude, 3)) AS dropoff_lat,
         FORMAT('%.3f', ROUND(dropoff_longitude, 3)) AS dropoff_lng,
         AVG(TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND)) AS avg_taxi_duration_seconds
  FROM `bigquery-public-data.new_york.tlc_yellow_trips_2016`
  WHERE EXTRACT(YEAR FROM pickup_datetime) = 2016
    AND pickup_latitude IS NOT NULL AND pickup_longitude IS NOT NULL
    AND dropoff_latitude IS NOT NULL AND dropoff_longitude IS NOT NULL
  GROUP BY pickup_lat, pickup_lng, dropoff_lat, dropoff_lng
),
routes AS (
  SELECT cb.*, tr.avg_taxi_duration_seconds
  FROM citibike_routes cb
  LEFT JOIN taxi_routes tr
  ON cb.start_lat = tr.pickup_lat AND cb.start_lng = tr.pickup_lng
     AND cb.end_lat = tr.dropoff_lat AND cb.end_lng = tr.dropoff_lng
),
faster_routes AS (
  SELECT *
  FROM routes
  WHERE avg_taxi_duration_seconds IS NOT NULL
    AND avg_bike_duration_seconds < avg_taxi_duration_seconds
),
max_duration_route AS (
  SELECT *
  FROM faster_routes
  ORDER BY avg_bike_duration_seconds DESC
  LIMIT 1
),
start_station_names AS (
  SELECT FORMAT('%.3f', ROUND(start_station_latitude, 3)) AS start_lat,
         FORMAT('%.3f', ROUND(start_station_longitude, 3)) AS start_lng,
         start_station_name,
         COUNT(*) AS name_count
  FROM `bigquery-public-data.new_york.citibike_trips`
  WHERE EXTRACT(YEAR FROM starttime) = 2016
  GROUP BY start_lat, start_lng, start_station_name
),
start_station_names_ranked AS (
  SELECT start_lat, start_lng, start_station_name, name_count,
         ROW_NUMBER() OVER(PARTITION BY start_lat, start_lng ORDER BY name_count DESC) AS rn
  FROM start_station_names
),
selected_start_station AS (
  SELECT start_lat, start_lng, start_station_name
  FROM start_station_names_ranked
  WHERE rn = 1
)
SELECT s.start_station_name
FROM max_duration_route mdr
LEFT JOIN selected_start_station s
ON mdr.start_lat = s.start_lat AND mdr.start_lng = s.start_lng