SELECT MAX(num_trips) AS highest_num_trips
FROM (
  SELECT DATE(`start_time`) AS trip_date, COUNT(*) AS num_trips
  FROM `bigquery-public-data.austin_bikeshare.bikeshare_trips`
  WHERE `bike_type` = 'electric'
    AND `duration_minutes` > 10
    AND `subscriber_type` = 'Student Membership'
    AND `start_station_name` NOT IN ('Mobile Station', 'Repair Shop')
    AND `end_station_name` NOT IN ('Mobile Station', 'Repair Shop')
  GROUP BY trip_date
)