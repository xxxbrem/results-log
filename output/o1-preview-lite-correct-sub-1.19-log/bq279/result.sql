WITH trips AS (
  SELECT
    EXTRACT(YEAR FROM start_time) AS Year,
    CAST(start_station_id AS INT64) AS station_id
  FROM `bigquery-public-data.austin_bikeshare.bikeshare_trips`
  WHERE start_station_id IS NOT NULL
    AND EXTRACT(YEAR FROM start_time) IN (2013, 2014)
),
stations_with_status AS (
  SELECT station_id, LOWER(status) AS Status
  FROM `bigquery-public-data.austin_bikeshare.bikeshare_stations`
)
SELECT
  Year,
  Status,
  COUNT(DISTINCT t.station_id) AS Number_of_Stations
FROM trips t
JOIN stations_with_status s ON t.station_id = s.station_id
GROUP BY Year, Status
ORDER BY Year, Status;