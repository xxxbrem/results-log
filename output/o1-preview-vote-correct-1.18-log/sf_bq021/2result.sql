WITH citi_bike_trips_2016 AS (
    SELECT
        *,
        ROUND("start_station_latitude", 3) AS "start_lat",
        ROUND("start_station_longitude", 3) AS "start_lng",
        ROUND("end_station_latitude", 3) AS "end_lat",
        ROUND("end_station_longitude", 3) AS "end_lng",
        TO_TIMESTAMP("starttime" / 1000000) AS "start_timestamp"
    FROM "NEW_YORK"."NEW_YORK"."CITIBIKE_TRIPS"
    WHERE TO_TIMESTAMP("starttime" / 1000000) BETWEEN '2016-01-01' AND '2016-12-31 23:59:59'
        AND "start_station_latitude" IS NOT NULL AND "start_station_longitude" IS NOT NULL
        AND "end_station_latitude" IS NOT NULL AND "end_station_longitude" IS NOT NULL
        AND "start_station_latitude" != 0 AND "start_station_longitude" != 0
        AND "end_station_latitude" != 0 AND "end_station_longitude" != 0
),
citi_bike_routes AS (
    SELECT
        "start_lat",
        "start_lng",
        "end_lat",
        "end_lng",
        COUNT(*) AS "trip_count"
    FROM citi_bike_trips_2016
    GROUP BY 1,2,3,4
    ORDER BY "trip_count" DESC
    LIMIT 20
),
bike_route_avg_durations AS (
    SELECT
        cbr."start_lat",
        cbr."start_lng",
        cbr."end_lat",
        cbr."end_lng",
        cbr."trip_count",
        AVG(cbt."tripduration") AS "avg_bike_duration"
    FROM citi_bike_routes cbr
    JOIN citi_bike_trips_2016 cbt
        ON cbt."start_lat" = cbr."start_lat" AND cbt."start_lng" = cbr."start_lng"
        AND cbt."end_lat" = cbr."end_lat" AND cbt."end_lng" = cbr."end_lng"
    GROUP BY cbr."start_lat", cbr."start_lng", cbr."end_lat", cbr."end_lng", cbr."trip_count"
),
taxi_trips_2016 AS (
    SELECT
        *,
        ROUND("pickup_latitude", 3) AS "start_lat",
        ROUND("pickup_longitude", 3) AS "start_lng",
        ROUND("dropoff_latitude", 3) AS "end_lat",
        ROUND("dropoff_longitude", 3) AS "end_lng",
        TO_TIMESTAMP("pickup_datetime" / 1000000) AS "pickup_timestamp",
        TO_TIMESTAMP("dropoff_datetime" / 1000000) AS "dropoff_timestamp",
        DATEDIFF('second', TO_TIMESTAMP("pickup_datetime" / 1000000), TO_TIMESTAMP("dropoff_datetime" / 1000000)) AS "trip_duration"
    FROM "NEW_YORK"."NEW_YORK"."TLC_YELLOW_TRIPS_2016"
    WHERE TO_TIMESTAMP("pickup_datetime" / 1000000) BETWEEN '2016-01-01' AND '2016-12-31 23:59:59'
        AND "pickup_latitude" IS NOT NULL AND "pickup_longitude" IS NOT NULL
        AND "dropoff_latitude" IS NOT NULL AND "dropoff_longitude" IS NOT NULL
        AND "pickup_latitude" != 0 AND "pickup_longitude" != 0
        AND "dropoff_latitude" != 0 AND "dropoff_longitude" != 0
),
taxi_route_avg_durations AS (
    SELECT
        tt."start_lat",
        tt."start_lng",
        tt."end_lat",
        tt."end_lng",
        AVG(tt."trip_duration") AS "avg_taxi_duration"
    FROM taxi_trips_2016 tt
    JOIN citi_bike_routes cbr
        ON tt."start_lat" = cbr."start_lat" AND tt."start_lng" = cbr."start_lng"
        AND tt."end_lat" = cbr."end_lat" AND tt."end_lng" = cbr."end_lng"
    GROUP BY 1,2,3,4
),
combined_routes AS (
    SELECT
        bd."start_lat",
        bd."start_lng",
        bd."end_lat",
        bd."end_lng",
        bd."avg_bike_duration",
        td."avg_taxi_duration",
        bd."trip_count"
    FROM bike_route_avg_durations bd
    INNER JOIN taxi_route_avg_durations td
        ON bd."start_lat" = td."start_lat" AND bd."start_lng" = td."start_lng"
        AND bd."end_lat" = td."end_lat" AND bd."end_lng" = td."end_lng"
    WHERE bd."avg_bike_duration" < td."avg_taxi_duration"
),
max_duration_route AS (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY "avg_bike_duration" DESC NULLS LAST) AS rn
    FROM combined_routes
),
selected_route AS (
    SELECT *
    FROM max_duration_route
    WHERE rn = 1
),
start_station_name AS (
    SELECT
        cbt."start_station_name"
    FROM citi_bike_trips_2016 cbt
    JOIN selected_route sr
        ON cbt."start_lat" = sr."start_lat" AND cbt."start_lng" = sr."start_lng"
        AND cbt."end_lat" = sr."end_lat" AND cbt."end_lng" = sr."end_lng"
    GROUP BY cbt."start_station_name"
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
SELECT "start_station_name"
FROM start_station_name;