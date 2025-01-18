SELECT
  z."borough" AS "Borough",
  ROUND(
    (SUM(CASE WHEN t."tip_amount" = 0 THEN 1 ELSE 0 END)::DECIMAL / COUNT(*) * 100),
    4
  ) AS "Percentage_No_Tips"
FROM
  "NEW_YORK_PLUS"."NEW_YORK_TAXI_TRIPS"."TLC_YELLOW_TRIPS_2016" t
JOIN
  "NEW_YORK_PLUS"."NEW_YORK_TAXI_TRIPS"."TAXI_ZONE_GEOM" z
    ON t."pickup_location_id" = z."zone_id"
WHERE
  TO_TIMESTAMP(t."pickup_datetime" / 1000000) BETWEEN '2016-01-01' AND '2016-01-07'
  AND t."dropoff_datetime" > t."pickup_datetime"
  AND t."passenger_count" > 0
  AND t."trip_distance" >= 0
  AND t."tip_amount" >= 0
  AND t."tolls_amount" >= 0
  AND t."mta_tax" >= 0
  AND t."fare_amount" >= 0
  AND t."total_amount" >= 0
  AND z."borough" IN ('Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island')
GROUP BY
  z."borough";