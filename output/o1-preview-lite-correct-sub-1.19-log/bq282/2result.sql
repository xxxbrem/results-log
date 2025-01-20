SELECT s_start.council_district AS council_district_code
FROM `bigquery-public-data.austin_bikeshare.bikeshare_trips` AS t
JOIN `bigquery-public-data.austin_bikeshare.bikeshare_stations` AS s_start
  ON t.start_station_id = s_start.station_id
JOIN `bigquery-public-data.austin_bikeshare.bikeshare_stations` AS s_end
  ON SAFE_CAST(t.end_station_id AS INT64) = s_end.station_id
WHERE t.start_station_id != SAFE_CAST(t.end_station_id AS INT64)
  AND s_start.council_district = s_end.council_district
  AND s_start.status = 'active'
  AND s_end.status = 'active'
GROUP BY s_start.council_district
ORDER BY COUNT(*) DESC
LIMIT 1;