WITH bike_routes AS (
    SELECT
        "start_station_name",
        "end_station_name",
        ROUND("start_station_latitude", 3) AS "start_lat_rounded",
        ROUND("start_station_longitude", 3) AS "start_lon_rounded",
        ROUND("end_station_latitude", 3) AS "end_lat_rounded",
        ROUND("end_station_longitude", 3) AS "end_lon_rounded",
        COUNT(*) AS "trip_count",
        AVG("tripduration") AS "avg_bike_duration"
    FROM
        "NEW_YORK"."NEW_YORK"."CITIBIKE_TRIPS"
    WHERE
        EXTRACT(year FROM TO_TIMESTAMP("starttime" / 1000000)) = 2016
        AND "start_station_latitude" IS NOT NULL AND "start_station_longitude" IS NOT NULL
        AND "end_station_latitude" IS NOT NULL AND "end_station_longitude" IS NOT NULL
    GROUP BY
        "start_station_name",
        "end_station_name",
        ROUND("start_station_latitude", 3),
        ROUND("start_station_longitude", 3),
        ROUND("end_station_latitude", 3),
        ROUND("end_station_longitude", 3)
    ORDER BY
        "trip_count" DESC
    LIMIT 20
),
taxi_avg_durations AS (
    SELECT
        ROUND("pickup_latitude", 3) AS "start_lat_rounded",
        ROUND("pickup_longitude", 3) AS "start_lon_rounded",
        ROUND("dropoff_latitude", 3) AS "end_lat_rounded",
        ROUND("dropoff_longitude", 3) AS "end_lon_rounded",
        AVG( ("dropoff_datetime" - "pickup_datetime") / 1000000 ) AS "avg_taxi_duration"
    FROM
        "NEW_YORK"."NEW_YORK"."TLC_YELLOW_TRIPS_2016"
    WHERE
        EXTRACT(year FROM TO_TIMESTAMP("pickup_datetime" / 1000000)) = 2016
        AND "pickup_latitude" IS NOT NULL AND "pickup_longitude" IS NOT NULL
        AND "dropoff_latitude" IS NOT NULL AND "dropoff_longitude" IS NOT NULL
        AND "pickup_latitude" <> 0 AND "pickup_longitude" <> 0
        AND "dropoff_latitude" <> 0 AND "dropoff_longitude" <> 0
        AND ("dropoff_datetime" - "pickup_datetime") > 0
    GROUP BY
        ROUND("pickup_latitude", 3),
        ROUND("pickup_longitude", 3),
        ROUND("dropoff_latitude", 3),
        ROUND("dropoff_longitude", 3)
)
SELECT
    br."start_station_name"
FROM
    bike_routes br
JOIN
    taxi_avg_durations td
ON
    br."start_lat_rounded" = td."start_lat_rounded"
    AND br."start_lon_rounded" = td."start_lon_rounded"
    AND br."end_lat_rounded" = td."end_lat_rounded"
    AND br."end_lon_rounded" = td."end_lon_rounded"
WHERE
    br."avg_bike_duration" < td."avg_taxi_duration"
ORDER BY
    br."avg_bike_duration" DESC NULLS LAST
LIMIT 1;