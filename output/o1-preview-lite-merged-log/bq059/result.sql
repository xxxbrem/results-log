SELECT ROUND(MAX(trip_speed_m_per_s), 4) AS max_avg_speed_m_per_s
FROM (
  SELECT t.trip_id,
         t.duration_sec,
         ST_DISTANCE(
           ST_GEOGPOINT(t.start_station_longitude, t.start_station_latitude),
           ST_GEOGPOINT(t.end_station_longitude, t.end_station_latitude)
         ) AS trip_distance_meters,
         ST_DISTANCE(
           ST_GEOGPOINT(t.start_station_longitude, t.start_station_latitude),
           ST_GEOGPOINT(t.end_station_longitude, t.end_station_latitude)
         ) / t.duration_sec AS trip_speed_m_per_s
  FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_trips` t
  WHERE (
    t.start_station_id IN (
      SELECT CAST(station_id AS INT64)
      FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info`
      WHERE region_id = (
        SELECT region_id
        FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_regions`
        WHERE name = 'Berkeley'
      )
    )
    OR t.end_station_id IN (
      SELECT CAST(station_id AS INT64)
      FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info`
      WHERE region_id = (
        SELECT region_id
        FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_regions`
        WHERE name = 'Berkeley'
      )
    )
  )
  AND t.duration_sec > 0
  AND ST_DISTANCE(
    ST_GEOGPOINT(t.start_station_longitude, t.start_station_latitude),
    ST_GEOGPOINT(t.end_station_longitude, t.end_station_latitude)
  ) > 1000
) AS trips_with_speed;