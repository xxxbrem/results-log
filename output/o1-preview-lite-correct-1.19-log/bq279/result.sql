SELECT
  EXTRACT(YEAR FROM t.start_time) AS Year,
  bs.status AS Status,
  COUNT(DISTINCT bs.station_id) AS Station_Count
FROM `bigquery-public-data.austin_bikeshare.bikeshare_trips` AS t
JOIN `bigquery-public-data.austin_bikeshare.bikeshare_stations` AS bs
  ON bs.station_id = CAST(t.start_station_id AS INT64)
WHERE EXTRACT(YEAR FROM t.start_time) IN (2013, 2014)
  AND t.start_station_id IS NOT NULL
GROUP BY Year, Status
ORDER BY Year, Status;