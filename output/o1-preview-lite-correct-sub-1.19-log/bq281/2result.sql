SELECT MAX(num_trips) AS highest_num_trips
FROM (
  SELECT DATE(start_time) AS trip_date, COUNT(*) AS num_trips
  FROM `bigquery-public-data.austin_bikeshare.bikeshare_trips`
  WHERE subscriber_type = 'Student Membership'
    AND bike_type = 'electric'
    AND duration_minutes > 10
    AND start_station_name IS NOT NULL
    AND start_station_name <> ''
    AND end_station_name IS NOT NULL
    AND end_station_name <> ''
    AND LOWER(start_station_name) NOT IN ('mobile station', 'repair shop')
    AND LOWER(end_station_name) NOT IN ('mobile station', 'repair shop')
  GROUP BY trip_date
)