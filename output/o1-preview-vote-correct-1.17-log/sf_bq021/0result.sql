WITH citibike_top20 AS (
  SELECT
    TRY_TO_NUMBER("start_station_id") AS "start_station_id",
    TRY_TO_NUMBER("end_station_id") AS "end_station_id",
    COUNT(*) AS "trip_count"
  FROM "NEW_YORK"."NEW_YORK"."CITIBIKE_TRIPS"
  WHERE "starttime" >= 1451606400000000 AND "starttime" < 1483228800000000
    AND TRY_TO_NUMBER("start_station_id") IS NOT NULL
    AND TRY_TO_NUMBER("end_station_id") IS NOT NULL
  GROUP BY TRY_TO_NUMBER("start_station_id"), TRY_TO_NUMBER("end_station_id")
  ORDER BY "trip_count" DESC NULLS LAST
  LIMIT 20
),
station_coords AS (
  SELECT
    TRY_TO_NUMBER("station_id") AS "station_id_num",
    "name",
    "latitude",
    "longitude"
  FROM "NEW_YORK"."NEW_YORK"."CITIBIKE_STATIONS"
  WHERE TRY_TO_NUMBER("station_id") IS NOT NULL
),
bike_routes AS (
  SELECT
    cb."start_station_id",
    cb."end_station_id",
    cb."trip_count",
    sc_start."latitude" AS "start_latitude",
    sc_start."longitude" AS "start_longitude",
    sc_end."latitude" AS "end_latitude",
    sc_end."longitude" AS "end_longitude",
    sc_start."name" AS "start_station_name"
  FROM citibike_top20 cb
  JOIN station_coords sc_start ON cb."start_station_id" = sc_start."station_id_num"
  JOIN station_coords sc_end ON cb."end_station_id" = sc_end."station_id_num"
),
bike_avg_durations AS (
  SELECT
    TRY_TO_NUMBER(t."start_station_id") AS "start_station_id",
    TRY_TO_NUMBER(t."end_station_id") AS "end_station_id",
    AVG(t."tripduration") AS "avg_bike_duration"
  FROM "NEW_YORK"."NEW_YORK"."CITIBIKE_TRIPS" t
  WHERE t."starttime" >= 1451606400000000 AND t."starttime" < 1483228800000000
    AND TRY_TO_NUMBER(t."start_station_id") IS NOT NULL
    AND TRY_TO_NUMBER(t."end_station_id") IS NOT NULL
    AND (TRY_TO_NUMBER(t."start_station_id"), TRY_TO_NUMBER(t."end_station_id")) IN (
      SELECT "start_station_id", "end_station_id" FROM citibike_top20
    )
  GROUP BY TRY_TO_NUMBER(t."start_station_id"), TRY_TO_NUMBER(t."end_station_id")
),
taxi_trips AS (
  SELECT
    ROUND("pickup_latitude", 3) AS "pickup_lat_rounded",
    ROUND("pickup_longitude", 3) AS "pickup_lon_rounded",
    ROUND("dropoff_latitude", 3) AS "dropoff_lat_rounded",
    ROUND("dropoff_longitude", 3) AS "dropoff_lon_rounded",
    (("dropoff_datetime" - "pickup_datetime") / 1000000) AS "trip_duration"
  FROM "NEW_YORK"."NEW_YORK"."TLC_YELLOW_TRIPS_2016"
  WHERE "pickup_datetime" >= 1451606400000000 AND "pickup_datetime" < 1483228800000000
    AND "pickup_latitude" IS NOT NULL AND "pickup_longitude" IS NOT NULL
    AND "dropoff_latitude" IS NOT NULL AND "dropoff_longitude" IS NOT NULL
    AND "pickup_latitude" != 0 AND "pickup_longitude" != 0
    AND "dropoff_latitude" != 0 AND "dropoff_longitude" != 0
    AND ("dropoff_datetime" - "pickup_datetime") > 0
),
taxi_avg_durations AS (
  SELECT
    br."start_station_id",
    br."end_station_id",
    AVG(tt."trip_duration") AS "avg_taxi_duration"
  FROM bike_routes br
  JOIN taxi_trips tt
    ON ROUND(br."start_latitude", 3) = tt."pickup_lat_rounded"
   AND ROUND(br."start_longitude", 3) = tt."pickup_lon_rounded"
   AND ROUND(br."end_latitude", 3) = tt."dropoff_lat_rounded"
   AND ROUND(br."end_longitude", 3) = tt."dropoff_lon_rounded"
  GROUP BY br."start_station_id", br."end_station_id"
),
durations AS (
  SELECT
    bad."start_station_id",
    bad."end_station_id",
    bad."avg_bike_duration",
    tad."avg_taxi_duration"
  FROM bike_avg_durations bad
  JOIN taxi_avg_durations tad
    ON bad."start_station_id" = tad."start_station_id"
   AND bad."end_station_id" = tad."end_station_id"
  WHERE bad."avg_bike_duration" < tad."avg_taxi_duration"
)
SELECT
  br."start_station_name",
  ROUND(br."start_latitude", 3) AS "latitude",
  ROUND(br."start_longitude", 3) AS "longitude"
FROM durations
JOIN bike_routes br
  ON durations."start_station_id" = br."start_station_id"
 AND durations."end_station_id" = br."end_station_id"
ORDER BY durations."avg_bike_duration" DESC NULLS LAST
LIMIT 1;