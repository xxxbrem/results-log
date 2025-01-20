WITH berkeley_stations AS (
  SELECT CAST(station_id AS INT64) AS station_id
  FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info`
  WHERE region_id = 14
),
berkeley_trips AS (
  SELECT
    trip_id,
    duration_sec,
    ST_DISTANCE(
      ST_GEOGPOINT(start_station_longitude, start_station_latitude),
      ST_GEOGPOINT(end_station_longitude, end_station_latitude)
    ) AS trip_distance,
    ST_DISTANCE(
      ST_GEOGPOINT(start_station_longitude, start_station_latitude),
      ST_GEOGPOINT(end_station_longitude, end_station_latitude)
    ) / NULLIF(duration_sec, 0) AS average_speed
  FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_trips`
  WHERE
    start_station_id IN (SELECT station_id FROM berkeley_stations)
    OR end_station_id IN (SELECT station_id FROM berkeley_stations)
)
SELECT ROUND(MAX(average_speed), 1) AS highest_average_speed_m_per_s
FROM berkeley_trips
WHERE trip_distance > 1000;