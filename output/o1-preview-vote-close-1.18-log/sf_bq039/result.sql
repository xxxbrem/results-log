SELECT
  pz."zone_name" AS "Pickup_Zone",
  dz."zone_name" AS "Dropoff_Zone",
  ROUND(((t."dropoff_datetime" - t."pickup_datetime") / (1000000 * 60)), 4) AS "Trip_Duration_Minutes",
  ROUND(
    CASE
      WHEN (t."dropoff_datetime" - t."pickup_datetime") > 0 THEN
        (t."trip_distance" / ((t."dropoff_datetime" - t."pickup_datetime") / (1000000 * 3600)))
      ELSE NULL
    END
  , 4) AS "Driving_Speed_MPH",
  ROUND((t."tip_amount" / t."fare_amount") * 100, 4) AS "Tip_Rate"
FROM "NEW_YORK_PLUS"."NEW_YORK_TAXI_TRIPS"."TLC_YELLOW_TRIPS_2016" t
LEFT JOIN "NEW_YORK_PLUS"."NEW_YORK_TAXI_TRIPS"."TAXI_ZONE_GEOM" pz
  ON t."pickup_location_id" = pz."zone_id"
LEFT JOIN "NEW_YORK_PLUS"."NEW_YORK_TAXI_TRIPS"."TAXI_ZONE_GEOM" dz
  ON t."dropoff_location_id" = dz."zone_id"
WHERE t."pickup_datetime" BETWEEN 1467331200000000 AND 1467935999000000
  AND t."passenger_count" > 5
  AND t."trip_distance" >= 10
  AND t."fare_amount" > 0
  AND (t."dropoff_datetime" - t."pickup_datetime") > 0
ORDER BY t."total_amount" DESC NULLS LAST
LIMIT 10;