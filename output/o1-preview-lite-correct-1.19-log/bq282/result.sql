SELECT s_start.council_district
FROM `bigquery-public-data.austin_bikeshare.bikeshare_trips` t
JOIN `bigquery-public-data.austin_bikeshare.bikeshare_stations` s_start
  ON t.start_station_id = s_start.station_id
JOIN `bigquery-public-data.austin_bikeshare.bikeshare_stations` s_end
  ON SAFE_CAST(t.end_station_id AS INT64) = s_end.station_id
WHERE s_start.council_district = s_end.council_district
  AND s_start.council_district IS NOT NULL
  AND t.start_station_id != SAFE_CAST(t.end_station_id AS INT64)
  AND SAFE_CAST(t.end_station_id AS INT64) IS NOT NULL
GROUP BY s_start.council_district
ORDER BY COUNT(*) DESC
LIMIT 1;