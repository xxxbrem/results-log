SELECT MAX(num_rides) AS Highest_number_of_rides
FROM (
  SELECT DATE(start_time) AS ride_date, COUNT(*) AS num_rides
  FROM `bigquery-public-data.austin_bikeshare.bikeshare_trips`
  WHERE subscriber_type = 'Student Membership'
    AND bike_type = 'electric'
    AND duration_minutes > 10
    AND LOWER(start_station_name) NOT LIKE '%mobile station%'
    AND LOWER(start_station_name) NOT LIKE '%repair shop%'
    AND LOWER(end_station_name) NOT LIKE '%mobile station%'
    AND LOWER(end_station_name) NOT LIKE '%repair shop%'
  GROUP BY ride_date
)