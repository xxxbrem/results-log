SELECT
    tz."borough",
    ROUND(
        100.0 * SUM(CASE WHEN ty."tip_amount" = 0 THEN 1 ELSE 0 END) / COUNT(*),
        4
    ) AS "percentage_no_tips"
FROM
    "NEW_YORK_PLUS"."NEW_YORK_TAXI_TRIPS"."TLC_YELLOW_TRIPS_2016" ty
JOIN
    "NEW_YORK_PLUS"."NEW_YORK_TAXI_TRIPS"."TAXI_ZONE_GEOM" tz
    ON ty."dropoff_location_id" = tz."zone_id"
WHERE
    TO_TIMESTAMP_LTZ(ty."pickup_datetime", 6) BETWEEN '2016-01-01 00:00:00' AND '2016-01-07 23:59:59'
    AND ty."dropoff_datetime" > ty."pickup_datetime"
    AND ty."passenger_count" > 0
    AND ty."trip_distance" >= 0
    AND ty."tip_amount" >= 0
    AND ty."tolls_amount" >= 0
    AND ty."mta_tax" >= 0
    AND ty."fare_amount" >= 0
    AND ty."total_amount" >= 0
    AND tz."borough" IN ('Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island')
GROUP BY
    tz."borough";