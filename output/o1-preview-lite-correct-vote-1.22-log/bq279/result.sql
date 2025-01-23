WITH total_stations AS (
  SELECT COUNT(DISTINCT station_id) AS total_stations
  FROM `bigquery-public-data.austin_bikeshare.bikeshare_stations`
),
active_stations AS (
  SELECT
    EXTRACT(YEAR FROM start_time) AS Year,
    COUNT(DISTINCT start_station_id) AS Number_of_Stations_active
  FROM
    `bigquery-public-data.austin_bikeshare.bikeshare_trips`
  WHERE
    EXTRACT(YEAR FROM start_time) IN (2013, 2014)
    AND start_station_id IS NOT NULL
  GROUP BY
    Year
)
SELECT
  a.Year,
  a.Number_of_Stations_active,
  (t.total_stations - a.Number_of_Stations_active) AS Number_of_Stations_closed
FROM
  active_stations a,
  total_stations t
ORDER BY
  a.Year;