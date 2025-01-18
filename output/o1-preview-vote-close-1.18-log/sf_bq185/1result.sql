SELECT ROUND(AVG((t."dropoff_datetime" - t."pickup_datetime") / 60000000.0), 4) AS "Average_Trip_Duration_in_Minutes"
FROM "NEW_YORK_PLUS"."NEW_YORK_TAXI_TRIPS"."TLC_YELLOW_TRIPS_2016" AS t
INNER JOIN "NEW_YORK_PLUS"."NEW_YORK_TAXI_TRIPS"."TAXI_ZONE_GEOM" AS z
  ON t."pickup_location_id" = z."zone_id"
WHERE 
  z."borough" = 'Brooklyn' AND
  t."passenger_count" > 3 AND
  t."trip_distance" >= 10 AND
  t."pickup_datetime" BETWEEN 1454284800000000 AND 1454899199000000 AND
  t."dropoff_datetime" > t."pickup_datetime";