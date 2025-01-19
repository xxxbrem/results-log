SELECT MAX(rides_per_day) AS "Highest_number_of_rides"
FROM (
    SELECT
        TO_DATE(TO_TIMESTAMP_NTZ("start_time" / 1000000)) AS ride_date,
        COUNT(*) AS rides_per_day
    FROM AUSTIN.AUSTIN_BIKESHARE.BIKESHARE_TRIPS
    WHERE
        "subscriber_type" = 'Student Membership'
        AND "duration_minutes" > 10
        AND "bike_type" = 'electric'
        AND "start_station_name" NOT ILIKE '%Mobile Station%'
        AND "start_station_name" NOT ILIKE '%Repair Shop%'
        AND "end_station_name" NOT ILIKE '%Mobile Station%'
        AND "end_station_name" NOT ILIKE '%Repair Shop%'
    GROUP BY ride_date
) AS daily_counts;