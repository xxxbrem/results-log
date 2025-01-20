SELECT
  ROUND(MAX(ST_DISTANCE(trips.start_station_geom, trips.end_station_geom) / trips.duration_sec), 4) AS highest_average_speed_m_per_s
FROM
  `bigquery-public-data.san_francisco_bikeshare.bikeshare_trips` AS trips
WHERE
  (CAST(trips.start_station_id AS INT64) IN (
    SELECT CAST(station_info.station_id AS INT64)
    FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info` AS station_info
    WHERE station_info.region_id = 14
  ) OR CAST(trips.end_station_id AS INT64) IN (
    SELECT CAST(station_info.station_id AS INT64)
    FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info` AS station_info
    WHERE station_info.region_id = 14
  ))
  AND ST_DISTANCE(trips.start_station_geom, trips.end_station_geom) > 1000
  AND trips.duration_sec > 0;