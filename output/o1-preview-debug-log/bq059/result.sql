WITH berkeley_stations AS (
  SELECT CAST(station_id AS INT64) AS station_id
  FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info`
  WHERE region_id = 14
),
berkeley_trips AS (
  SELECT
    *,
    ST_DISTANCE(
      ST_GEOGPOINT(start_station_longitude, start_station_latitude),
      ST_GEOGPOINT(end_station_longitude, end_station_latitude)
    ) AS trip_distance_meters
  FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_trips`
  WHERE CAST(start_station_id AS INT64) IN (SELECT station_id FROM berkeley_stations)
     OR CAST(end_station_id AS INT64) IN (SELECT station_id FROM berkeley_stations)
),
valid_trips AS (
  SELECT
    *,
    trip_distance_meters / duration_sec AS average_speed_m_per_sec
  FROM berkeley_trips
  WHERE trip_distance_meters > 1000
    AND duration_sec > 0
    AND trip_distance_meters IS NOT NULL
)
SELECT ROUND(MAX(average_speed_m_per_sec), 1) AS highest_average_speed
FROM valid_trips;