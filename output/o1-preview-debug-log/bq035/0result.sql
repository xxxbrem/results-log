SELECT
  bike_number,
  ROUND(SUM(ST_DISTANCE(
    ST_GEOGPOINT(start_station.longitude, start_station.latitude),
    ST_GEOGPOINT(end_station.longitude, end_station.latitude)
  )), 4) AS total_distance_meters
FROM
  `bigquery-public-data.san_francisco.bikeshare_trips` AS trips
JOIN
  `bigquery-public-data.san_francisco.bikeshare_stations` AS start_station
  ON trips.start_station_id = start_station.station_id
JOIN
  `bigquery-public-data.san_francisco.bikeshare_stations` AS end_station
  ON trips.end_station_id = end_station.station_id
GROUP BY
  bike_number
ORDER BY
  bike_number;