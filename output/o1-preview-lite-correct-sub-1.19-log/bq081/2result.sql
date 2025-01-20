SELECT
  region_name,
  trip_id,
  duration_sec,
  start_date,
  start_station_name,
  member_gender
FROM (
  SELECT
    r.name AS region_name,
    t.trip_id,
    t.duration_sec,
    t.start_date,
    s.name AS start_station_name,
    t.member_gender,
    ROW_NUMBER() OVER (PARTITION BY r.region_id ORDER BY t.start_date DESC) AS rn
  FROM
    `bigquery-public-data.san_francisco_bikeshare.bikeshare_trips` t
  JOIN
    `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info` s
  ON
    t.start_station_id = CAST(s.station_id AS INT64)
  JOIN
    `bigquery-public-data.san_francisco_bikeshare.bikeshare_regions` r
  ON
    s.region_id = r.region_id
  WHERE
    DATE(t.start_date) BETWEEN '2014-01-01' AND '2017-12-31'
)
WHERE rn = 1