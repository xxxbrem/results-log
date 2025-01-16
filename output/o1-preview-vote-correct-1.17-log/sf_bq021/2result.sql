WITH bike_routes AS (
    SELECT
        MAX("start_station_name") AS "start_station_name",
        ROUND("start_station_latitude", 4) AS "start_station_latitude",
        ROUND("start_station_longitude", 4) AS "start_station_longitude",
        ROUND("end_station_latitude", 4) AS "end_station_latitude",
        ROUND("end_station_longitude", 4) AS "end_station_longitude",
        ST_MAKEPOINT(ROUND("start_station_longitude", 4), ROUND("start_station_latitude", 4)) AS "bike_start_point",
        ST_MAKEPOINT(ROUND("end_station_longitude", 4), ROUND("end_station_latitude", 4)) AS "bike_end_point",
        COUNT(*) AS "bike_trip_count",
        AVG("tripduration") AS "avg_bike_duration"
    FROM NEW_YORK.NEW_YORK.CITIBIKE_TRIPS
    WHERE
        TO_TIMESTAMP_NTZ("starttime" / 1e6) >= '2016-01-01'
        AND TO_TIMESTAMP_NTZ("starttime" / 1e6) < '2017-01-01'
        AND "start_station_latitude" BETWEEN -90 AND 90
        AND "start_station_longitude" BETWEEN -180 AND 180
        AND "end_station_latitude" BETWEEN -90 AND 90
        AND "end_station_longitude" BETWEEN -180 AND 180
    GROUP BY
        ROUND("start_station_latitude", 4),
        ROUND("start_station_longitude", 4),
        ROUND("end_station_latitude", 4),
        ROUND("end_station_longitude", 4)
    ORDER BY "bike_trip_count" DESC NULLS LAST
    LIMIT 20
),
taxi_routes AS (
    SELECT
        ROUND("pickup_latitude", 4) AS "pickup_latitude",
        ROUND("pickup_longitude", 4) AS "pickup_longitude",
        ROUND("dropoff_latitude", 4) AS "dropoff_latitude",
        ROUND("dropoff_longitude", 4) AS "dropoff_longitude",
        ST_MAKEPOINT(ROUND("pickup_longitude", 4), ROUND("pickup_latitude", 4)) AS "taxi_start_point",
        ST_MAKEPOINT(ROUND("dropoff_longitude", 4), ROUND("dropoff_latitude", 4)) AS "taxi_end_point",
        AVG(("dropoff_datetime" - "pickup_datetime") / 1e6) AS "avg_taxi_duration"
    FROM NEW_YORK.NEW_YORK.TLC_YELLOW_TRIPS_2016
    WHERE
        TO_TIMESTAMP_NTZ("pickup_datetime" / 1e6) >= '2016-01-01'
        AND TO_TIMESTAMP_NTZ("pickup_datetime" / 1e6) < '2017-01-01'
        AND "pickup_latitude" IS NOT NULL
        AND "pickup_longitude" IS NOT NULL
        AND "dropoff_latitude" IS NOT NULL
        AND "dropoff_longitude" IS NOT NULL
        AND "pickup_latitude" BETWEEN -90 AND 90
        AND "pickup_longitude" BETWEEN -180 AND 180
        AND "dropoff_latitude" BETWEEN -90 AND 90
        AND "dropoff_longitude" BETWEEN -180 AND 180
    GROUP BY
        ROUND("pickup_latitude", 4),
        ROUND("pickup_longitude", 4),
        ROUND("dropoff_latitude", 4),
        ROUND("dropoff_longitude", 4)
)
SELECT
    b."start_station_name",
    b."start_station_latitude",
    b."start_station_longitude"
FROM bike_routes b
JOIN taxi_routes t
    ON ST_DISTANCE(b."bike_start_point", t."taxi_start_point") < 100  -- within 100 meters
    AND ST_DISTANCE(b."bike_end_point", t."taxi_end_point") < 100
WHERE b."avg_bike_duration" < t."avg_taxi_duration"
ORDER BY b."avg_bike_duration" DESC NULLS LAST
LIMIT 1;