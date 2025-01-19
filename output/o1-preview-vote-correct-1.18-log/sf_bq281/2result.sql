SELECT 
  MAX(number_of_rides) AS "Max_Rides"
FROM (
  SELECT 
    DATE(TO_TIMESTAMP_LTZ("start_time" / 1e6)) AS ride_date, 
    COUNT(*) AS number_of_rides
  FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
  WHERE
    "subscriber_type" = 'Student Membership' AND 
    "bike_type" = 'electric' AND
    "duration_minutes" > 10 AND
    "start_station_name" NOT ILIKE '%Mobile Station%' AND
    "start_station_name" NOT ILIKE '%Repair Shop%' AND
    "end_station_name" NOT ILIKE '%Mobile Station%' AND
    "end_station_name" NOT ILIKE '%Repair Shop%'
  GROUP BY ride_date
);