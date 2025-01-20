SELECT
  ROUND(MAX(average_speed), 1) AS highest_average_speed_m_per_s
FROM (
  SELECT
    ROUND(
      ST_DISTANCE(
        ST_GEOGPOINT(`start_station_longitude`, `start_station_latitude`),
        ST_GEOGPOINT(`end_station_longitude`, `end_station_latitude`)
      ) / NULLIF(`duration_sec`, 0),
      4
    ) AS average_speed
  FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_trips`
  WHERE (
    LOWER(`start_station_name`) LIKE '%berkeley%' OR
    LOWER(`end_station_name`) LIKE '%berkeley%'
  )
  AND ST_DISTANCE(
        ST_GEOGPOINT(`start_station_longitude`, `start_station_latitude`),
        ST_GEOGPOINT(`end_station_longitude`, `end_station_latitude`)
      ) > 1000
  AND `duration_sec` > 0
)