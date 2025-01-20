SELECT
  s_start.council_district AS council_district_code
FROM
  `bigquery-public-data.austin_bikeshare.bikeshare_trips` AS trips
JOIN
  `bigquery-public-data.austin_bikeshare.bikeshare_stations` AS s_start
  ON trips.start_station_id = s_start.station_id
JOIN
  `bigquery-public-data.austin_bikeshare.bikeshare_stations` AS s_end
  ON SAFE_CAST(trips.end_station_id AS INT64) = s_end.station_id
WHERE
  trips.start_station_id IS NOT NULL
  AND SAFE_CAST(trips.end_station_id AS INT64) IS NOT NULL
  AND s_start.council_district = s_end.council_district
  AND trips.start_station_id != SAFE_CAST(trips.end_station_id AS INT64)
GROUP BY
  council_district_code
ORDER BY
  COUNT(*) DESC
LIMIT 1;