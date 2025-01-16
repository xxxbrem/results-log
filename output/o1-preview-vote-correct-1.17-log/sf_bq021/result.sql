WITH citi_bike_2016 AS (
    SELECT
        "tripduration",
        "starttime",
        "start_station_name",
        ROUND("start_station_latitude", 4) AS "start_lat",
        ROUND("start_station_longitude", 4) AS "start_long",
        ROUND("end_station_latitude", 4) AS "end_lat",
        ROUND("end_station_longitude", 4) AS "end_long"
    FROM NEW_YORK.NEW_YORK.CITIBIKE_TRIPS
    WHERE "starttime" >= 1451606400000000 AND "starttime" < 1483228800000000
),
top_routes AS (
    SELECT
        "start_lat",
        "start_long",
        "end_lat",
        "end_long",
        COUNT(*) AS "trip_count"
    FROM citi_bike_2016
    GROUP BY "start_lat", "start_long", "end_lat", "end_long"
    ORDER BY "trip_count" DESC NULLS LAST
    LIMIT 20
),
citi_bike_avg AS (
    SELECT
        t."start_lat",
        t."start_long",
        t."end_lat",
        t."end_long",
        AVG(c."tripduration") AS "cb_avg_duration"
    FROM citi_bike_2016 c
    JOIN top_routes t
        ON c."start_lat" = t."start_lat"
        AND c."start_long" = t."start_long"
        AND c."end_lat" = t."end_lat"
        AND c."end_long" = t."end_long"
    GROUP BY t."start_lat", t."start_long", t."end_lat", t."end_long"
),
taxi_trips_2016 AS (
    SELECT
        ("dropoff_datetime" - "pickup_datetime") AS "trip_duration",
        ROUND("pickup_latitude", 4) AS "pickup_lat",
        ROUND("pickup_longitude", 4) AS "pickup_long",
        ROUND("dropoff_latitude", 4) AS "dropoff_lat",
        ROUND("dropoff_longitude", 4) AS "dropoff_long"
    FROM NEW_YORK.NEW_YORK.TLC_YELLOW_TRIPS_2016
    WHERE "pickup_datetime" >= 1451606400000000 AND "pickup_datetime" < 1483228800000000
        AND "pickup_latitude" IS NOT NULL AND "pickup_longitude" IS NOT NULL
        AND "dropoff_latitude" IS NOT NULL AND "dropoff_longitude" IS NOT NULL
),
taxi_avg AS (
    SELECT
        "pickup_lat",
        "pickup_long",
        "dropoff_lat",
        "dropoff_long",
        AVG("trip_duration") AS "taxi_avg_duration"
    FROM taxi_trips_2016
    GROUP BY "pickup_lat", "pickup_long", "dropoff_lat", "dropoff_long"
),
combined AS (
    SELECT
        cba."start_lat",
        cba."start_long",
        cba."end_lat",
        cba."end_long",
        cba."cb_avg_duration",
        ta."taxi_avg_duration"
    FROM citi_bike_avg cba
    JOIN taxi_avg ta
        ON cba."start_lat" = ta."pickup_lat"
        AND cba."start_long" = ta."pickup_long"
        AND cba."end_lat" = ta."dropoff_lat"
        AND cba."end_long" = ta."dropoff_long"
    WHERE cba."cb_avg_duration" < ta."taxi_avg_duration"
),
longest_duration_route AS (
    SELECT
        "start_lat",
        "start_long",
        "end_lat",
        "end_long",
        "cb_avg_duration"
    FROM combined
    ORDER BY "cb_avg_duration" DESC NULLS LAST
    LIMIT 1
)
SELECT DISTINCT
    c."start_station_name"
FROM citi_bike_2016 c
JOIN longest_duration_route ldr
    ON c."start_lat" = ldr."start_lat"
    AND c."start_long" = ldr."start_long"
ORDER BY c."start_station_name"
LIMIT 1;