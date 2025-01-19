WITH trips_with_station_and_region AS (
  SELECT
    t.trip_id,
    t.duration_sec,
    t.start_date,
    t.member_gender,
    s.name AS start_station_name,
    r.name AS region_name
  FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_trips` AS t
  JOIN `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info` AS s
    ON t.start_station_id = CAST(s.station_id AS INT64)
  JOIN `bigquery-public-data.san_francisco_bikeshare.bikeshare_regions` AS r
    ON s.region_id = r.region_id
  WHERE t.start_date BETWEEN '2014-01-01' AND '2017-12-31'
),
latest_trips AS (
  SELECT
    region_name,
    MAX(start_date) AS latest_start_date
  FROM trips_with_station_and_region
  GROUP BY region_name
)
SELECT
  t.region_name,
  t.trip_id,
  t.duration_sec,
  t.start_date,
  t.start_station_name,
  t.member_gender
FROM trips_with_station_and_region AS t
JOIN latest_trips AS l
  ON t.region_name = l.region_name AND t.start_date = l.latest_start_date
ORDER BY t.region_name;