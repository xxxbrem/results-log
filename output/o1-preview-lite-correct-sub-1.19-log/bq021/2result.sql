WITH bike_routes AS (
  SELECT
    ROUND(start_station_latitude, 3) AS start_lat,
    ROUND(start_station_longitude, 3) AS start_lon,
    ROUND(end_station_latitude, 3) AS end_lat,
    ROUND(end_station_longitude, 3) AS end_lon,
    COUNT(*) AS trip_count,
    AVG(tripduration) AS avg_bike_duration
  FROM `bigquery-public-data.new_york.citibike_trips`
  WHERE EXTRACT(YEAR FROM starttime) = 2016
    AND start_station_latitude IS NOT NULL
    AND start_station_longitude IS NOT NULL
    AND end_station_latitude IS NOT NULL
    AND end_station_longitude IS NOT NULL
    AND start_station_latitude != 0
    AND start_station_longitude != 0
    AND end_station_latitude != 0
    AND end_station_longitude != 0
    AND tripduration > 0
  GROUP BY start_lat, start_lon, end_lat, end_lon
  ORDER BY trip_count DESC
  LIMIT 20
),
taxi_routes AS (
  SELECT
    ROUND(pickup_latitude, 3) AS start_lat,
    ROUND(pickup_longitude, 3) AS start_lon,
    ROUND(dropoff_latitude, 3) AS end_lat,
    ROUND(dropoff_longitude, 3) AS end_lon,
    AVG(TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND)) AS avg_taxi_duration
  FROM `bigquery-public-data.new_york.tlc_yellow_trips_2016`
  WHERE EXTRACT(YEAR FROM pickup_datetime) = 2016
    AND pickup_latitude IS NOT NULL
    AND pickup_longitude IS NOT NULL
    AND dropoff_latitude IS NOT NULL
    AND dropoff_longitude IS NOT NULL
    AND pickup_latitude != 0
    AND pickup_longitude != 0
    AND dropoff_latitude != 0
    AND dropoff_longitude != 0
    AND TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) > 0
  GROUP BY start_lat, start_lon, end_lat, end_lon
)
SELECT
  start_station_name
FROM (
  SELECT
    br.start_lat,
    br.start_lon,
    br.end_lat,
    br.end_lon,
    br.avg_bike_duration,
    tr.avg_taxi_duration
  FROM bike_routes br
  JOIN taxi_routes tr
    ON br.start_lat = tr.start_lat
    AND br.start_lon = tr.start_lon
    AND br.end_lat = tr.end_lat
    AND br.end_lon = tr.end_lon
  WHERE br.avg_bike_duration < tr.avg_taxi_duration
  ORDER BY br.avg_bike_duration DESC, br.trip_count DESC
  LIMIT 1
) AS matched_route
JOIN (
  SELECT DISTINCT
    start_station_name,
    ROUND(start_station_latitude, 3) AS start_lat,
    ROUND(start_station_longitude, 3) AS start_lon
  FROM `bigquery-public-data.new_york.citibike_trips`
  WHERE EXTRACT(YEAR FROM starttime) = 2016
    AND start_station_name IS NOT NULL
    AND start_station_latitude IS NOT NULL
    AND start_station_longitude IS NOT NULL
    AND start_station_latitude != 0
    AND start_station_longitude != 0
) AS stations
ON matched_route.start_lat = stations.start_lat
   AND matched_route.start_lon = stations.start_lon
LIMIT 1;