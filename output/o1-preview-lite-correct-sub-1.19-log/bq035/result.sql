SELECT
  bike_number,
  ROUND(SUM(trip_distance_meters), 4) AS total_distance_meters
FROM (
  SELECT
    t.bike_number,
    ST_DISTANCE(
      ST_GEOGPOINT(s_start.longitude, s_start.latitude),
      ST_GEOGPOINT(s_end.longitude, s_end.latitude)
    ) AS trip_distance_meters
  FROM
    `bigquery-public-data.san_francisco.bikeshare_trips` AS t
  JOIN
    `bigquery-public-data.san_francisco.bikeshare_stations` AS s_start
      ON t.start_station_id = s_start.station_id
  JOIN
    `bigquery-public-data.san_francisco.bikeshare_stations` AS s_end
      ON t.end_station_id = s_end.station_id
)
GROUP BY
  bike_number
ORDER BY
  bike_number;