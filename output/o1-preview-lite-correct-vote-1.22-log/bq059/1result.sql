SELECT ROUND(MAX(average_speed_m_s), 1) AS highest_average_speed_m_s
FROM (
  SELECT ROUND(distance_meters / duration_sec, 4) AS average_speed_m_s
  FROM (
    SELECT t.trip_id, t.duration_sec,
      ST_DISTANCE(t.start_station_geom, t.end_station_geom) AS distance_meters
    FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_trips` AS t
    JOIN `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info` AS s_start
      ON t.start_station_id = CAST(s_start.station_id AS INT64)
    JOIN `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info` AS s_end
      ON t.end_station_id = CAST(s_end.station_id AS INT64)
    WHERE
      (
        s_start.region_id = (
          SELECT region_id
          FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_regions`
          WHERE name = 'Berkeley'
        )
        OR s_end.region_id = (
          SELECT region_id
          FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_regions`
          WHERE name = 'Berkeley'
        )
      )
      AND ST_DISTANCE(t.start_station_geom, t.end_station_geom) > 1000
      AND t.duration_sec > 0
  )
)