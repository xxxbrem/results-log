SELECT
  EXTRACT(YEAR FROM t.start_time) AS Year,
  s.status AS Status,
  COUNT(DISTINCT s.station_id) AS Number_of_Stations
FROM
  `bigquery-public-data.austin_bikeshare.bikeshare_trips` AS t
JOIN
  `bigquery-public-data.austin_bikeshare.bikeshare_stations` AS s
ON
  t.start_station_id = s.station_id
WHERE
  EXTRACT(YEAR FROM t.start_time) IN (2013, 2014)
GROUP BY
  Year,
  Status
ORDER BY
  Year,
  Status;