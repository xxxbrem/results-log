SELECT
  region_name,
  trip_id,
  duration_sec,
  start_date,
  start_station_name,
  member_gender
FROM (
  SELECT
    br.name AS region_name,
    bt.trip_id,
    bt.duration_sec,
    bt.start_date,
    bt.start_station_name,
    bt.member_gender,
    ROW_NUMBER() OVER (PARTITION BY br.region_id ORDER BY bt.start_date DESC) AS rn
  FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_trips` AS bt
  JOIN `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info` AS bsi
    ON bt.start_station_id = CAST(bsi.station_id AS INT64)
  JOIN `bigquery-public-data.san_francisco_bikeshare.bikeshare_regions` AS br
    ON bsi.region_id = br.region_id
  WHERE bt.start_date BETWEEN TIMESTAMP('2014-01-01') AND TIMESTAMP('2017-12-31')
)
WHERE rn = 1;