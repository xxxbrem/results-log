SELECT
  t.bike_number,
  ROUND(SUM(ST_DISTANCE(
    ST_GEOGPOINT(s_start.longitude, s_start.latitude),
    ST_GEOGPOINT(s_end.longitude, s_end.latitude)
  )) / 1000, 4) AS total_distance
FROM
  `bigquery-public-data.san_francisco.bikeshare_trips` t
JOIN `bigquery-public-data.san_francisco.bikeshare_stations` s_start
  ON t.start_station_id = s_start.station_id
JOIN `bigquery-public-data.san_francisco.bikeshare_stations` s_end
  ON t.end_station_id = s_end.station_id
GROUP BY t.bike_number
ORDER BY t.bike_number;