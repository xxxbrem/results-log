SELECT
  s1.council_district AS council_district_code
FROM
  `bigquery-public-data.austin_bikeshare.bikeshare_trips` AS t
JOIN
  `bigquery-public-data.austin_bikeshare.bikeshare_stations` AS s1
  ON t.start_station_id = s1.station_id
JOIN
  `bigquery-public-data.austin_bikeshare.bikeshare_stations` AS s2
  ON SAFE_CAST(t.end_station_id AS INT64) = s2.station_id
WHERE
  s1.council_district = s2.council_district
  AND t.start_station_id != SAFE_CAST(t.end_station_id AS INT64)
  AND s1.status = 'active'
  AND s2.status = 'active'
GROUP BY
  s1.council_district
ORDER BY
  COUNT(*) DESC
LIMIT 1;