SELECT MAX("daily_count") AS "Highest-number-of-electric-bike-rides"
FROM (
    SELECT DATE(TO_TIMESTAMP("start_time" / 1000000)) AS "ride_date",
           COUNT(*) AS "daily_count"
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
    WHERE "subscriber_type" = 'Student Membership'
      AND "bike_type" = 'electric'
      AND "duration_minutes" > 10
      AND "start_station_name" NOT IN ('Mobile Station', 'Repair Shop')
      AND "end_station_name" NOT IN ('Mobile Station', 'Repair Shop')
    GROUP BY "ride_date"
);