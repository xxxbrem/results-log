WITH citibike_routes AS (
  SELECT
    ROUND(start_station_latitude, 3) AS start_lat,
    ROUND(start_station_longitude, 3) AS start_lon,
    ROUND(end_station_latitude, 3) AS end_lat,
    ROUND(end_station_longitude, 3) AS end_lon,
    COUNT(*) AS trip_count,
    AVG(tripduration) AS avg_bike_duration
  FROM
    `bigquery-public-data.new_york.citibike_trips`
  WHERE
    EXTRACT(YEAR FROM starttime) = 2016
    AND tripduration > 0
    AND start_station_latitude IS NOT NULL
    AND start_station_longitude IS NOT NULL
    AND end_station_latitude IS NOT NULL
    AND end_station_longitude IS NOT NULL
    AND start_station_latitude != 0
    AND start_station_longitude != 0
    AND end_station_latitude != 0
    AND end_station_longitude != 0
  GROUP BY
    start_lat,
    start_lon,
    end_lat,
    end_lon
),
top20_citibike_routes AS (
  SELECT
    *
  FROM
    citibike_routes
  ORDER BY
    trip_count DESC
  LIMIT 20
),
taxi_routes AS (
  SELECT
    ROUND(pickup_latitude, 3) AS start_lat,
    ROUND(pickup_longitude, 3) AS start_lon,
    ROUND(dropoff_latitude, 3) AS end_lat,
    ROUND(dropoff_longitude, 3) AS end_lon,
    AVG(TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND)) AS avg_taxi_duration
  FROM
    `bigquery-public-data.new_york.tlc_yellow_trips_2016`
  WHERE
    pickup_datetime BETWEEN '2016-01-01' AND '2016-12-31'
    AND TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) > 0
    AND pickup_latitude IS NOT NULL
    AND pickup_longitude IS NOT NULL
    AND dropoff_latitude IS NOT NULL
    AND dropoff_longitude IS NOT NULL
    AND pickup_latitude BETWEEN 40 AND 41
    AND pickup_longitude BETWEEN -75 AND -73
    AND dropoff_latitude BETWEEN 40 AND 41
    AND dropoff_longitude BETWEEN -75 AND -73
  GROUP BY
    start_lat,
    start_lon,
    end_lat,
    end_lon
),
combined_routes AS (
  SELECT
    cb.start_lat,
    cb.start_lon,
    cb.end_lat,
    cb.end_lon,
    cb.trip_count,
    cb.avg_bike_duration,
    t.avg_taxi_duration
  FROM
    top20_citibike_routes cb
  JOIN
    taxi_routes t
  ON
    cb.start_lat = t.start_lat
    AND cb.start_lon = t.start_lon
    AND cb.end_lat = t.end_lat
    AND cb.end_lon = t.end_lon
  WHERE
    cb.avg_bike_duration < t.avg_taxi_duration
),
route_with_longest_avg_bike_duration AS (
  SELECT
    *
  FROM
    combined_routes
  ORDER BY
    avg_bike_duration DESC
  LIMIT 1
),
start_station AS (
  SELECT
    cbt.start_station_name,
    COUNT(*) AS station_trip_count
  FROM
    `bigquery-public-data.new_york.citibike_trips` cbt
  JOIN
    route_with_longest_avg_bike_duration r
  ON
    ROUND(cbt.start_station_latitude, 3) = r.start_lat
    AND ROUND(cbt.start_station_longitude, 3) = r.start_lon
    AND ROUND(cbt.end_station_latitude, 3) = r.end_lat
    AND ROUND(cbt.end_station_longitude, 3) = r.end_lon
  WHERE
    cbt.start_station_name IS NOT NULL
    AND EXTRACT(YEAR FROM cbt.starttime) = 2016
  GROUP BY
    cbt.start_station_name
  ORDER BY
    station_trip_count DESC
  LIMIT 1
)
SELECT
  start_station_name
FROM
  start_station;