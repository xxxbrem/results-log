SELECT
  ROUND(MAX(
    ST_DISTANCE(
      ST_GEOGPOINT(t.start_station_longitude, t.start_station_latitude),
      ST_GEOGPOINT(t.end_station_longitude, t.end_station_latitude)
    ) / t.duration_sec
  ), 1) AS max_average_speed_mps
FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_trips` t
WHERE (LOWER(t.start_station_name) LIKE '%berkeley%' OR LOWER(t.end_station_name) LIKE '%berkeley%')
  AND t.start_station_longitude IS NOT NULL
  AND t.start_station_latitude IS NOT NULL
  AND t.end_station_longitude IS NOT NULL
  AND t.end_station_latitude IS NOT NULL
  AND t.duration_sec > 0
  AND ST_DISTANCE(
      ST_GEOGPOINT(t.start_station_longitude, t.start_station_latitude),
      ST_GEOGPOINT(t.end_station_longitude, t.end_station_latitude)
    ) > 1000;