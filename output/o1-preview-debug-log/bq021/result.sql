WITH top_citi_bike_routes AS (
  SELECT 
    start_station_name,
    end_station_name,
    ROUND(start_station_latitude, 3) AS start_lat,
    ROUND(start_station_longitude, 3) AS start_lon,
    ROUND(end_station_latitude, 3) AS end_lat,
    ROUND(end_station_longitude, 3) AS end_lon,
    COUNT(*) AS trip_count,
    ROUND(AVG(tripduration), 4) AS avg_bike_duration
  FROM `bigquery-public-data.new_york.citibike_trips`
  WHERE EXTRACT(YEAR FROM starttime) = 2016
  GROUP BY start_station_name, end_station_name, start_lat, start_lon, end_lat, end_lon
  ORDER BY trip_count DESC
  LIMIT 20
),
taxi_trips_filtered AS (
  SELECT 
    ROUND(pickup_latitude, 3) AS pickup_lat,
    ROUND(pickup_longitude, 3) AS pickup_lon,
    ROUND(dropoff_latitude, 3) AS dropoff_lat,
    ROUND(dropoff_longitude, 3) AS dropoff_lon,
    ROUND(AVG(TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND)), 4) AS avg_taxi_duration
  FROM `bigquery-public-data.new_york.tlc_yellow_trips_2016`
  WHERE EXTRACT(YEAR FROM pickup_datetime) = 2016
    AND pickup_latitude IS NOT NULL
    AND pickup_longitude IS NOT NULL
    AND dropoff_latitude IS NOT NULL
    AND dropoff_longitude IS NOT NULL
    AND ABS(pickup_latitude) > 0
    AND ABS(pickup_longitude) > 0
    AND ABS(dropoff_latitude) > 0
    AND ABS(dropoff_longitude) > 0
  GROUP BY pickup_lat, pickup_lon, dropoff_lat, dropoff_lon
),
routes_with_taxi_data AS (
  SELECT 
    routes.start_station_name,
    routes.end_station_name,
    routes.avg_bike_duration,
    taxi.avg_taxi_duration
  FROM top_citi_bike_routes AS routes
  INNER JOIN taxi_trips_filtered AS taxi
    ON routes.start_lat = taxi.pickup_lat
    AND routes.start_lon = taxi.pickup_lon
    AND routes.end_lat = taxi.dropoff_lat
    AND routes.end_lon = taxi.dropoff_lon
),
bike_faster_routes AS (
  SELECT
    start_station_name,
    end_station_name,
    avg_bike_duration,
    avg_taxi_duration
  FROM routes_with_taxi_data
  WHERE avg_bike_duration < avg_taxi_duration
)
SELECT start_station_name
FROM bike_faster_routes
ORDER BY avg_bike_duration DESC
LIMIT 1;