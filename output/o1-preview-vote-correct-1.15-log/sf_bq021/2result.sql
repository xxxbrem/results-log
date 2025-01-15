WITH citi_bike_routes AS (
    SELECT
        "start_station_id",
        "end_station_id",
        MIN("start_station_name") AS "start_station_name",
        ROUND(AVG("start_station_latitude"), 3) AS "start_latitude_3dp",
        ROUND(AVG("start_station_longitude"), 3) AS "start_longitude_3dp",
        ROUND(AVG("end_station_latitude"), 3) AS "end_latitude_3dp",
        ROUND(AVG("end_station_longitude"), 3) AS "end_longitude_3dp",
        COUNT(*) AS "trip_count",
        AVG("tripduration") AS "avg_bike_duration"
    FROM
        "NEW_YORK"."NEW_YORK"."CITIBIKE_TRIPS"
    WHERE
        TO_TIMESTAMP_NTZ("starttime" / 1000000) >= '2016-01-01' AND
        TO_TIMESTAMP_NTZ("starttime" / 1000000) < '2017-01-01'
    GROUP BY
        "start_station_id", "end_station_id"
    ORDER BY
        "trip_count" DESC NULLS LAST
    LIMIT 20
),
taxi_trip_durations AS (
    SELECT
        ROUND("pickup_latitude", 3) AS "pickup_latitude_3dp",
        ROUND("pickup_longitude", 3) AS "pickup_longitude_3dp",
        ROUND("dropoff_latitude", 3) AS "dropoff_latitude_3dp",
        ROUND("dropoff_longitude", 3) AS "dropoff_longitude_3dp",
        AVG( ("dropoff_datetime" - "pickup_datetime") / 1000000 ) AS "avg_taxi_duration"
    FROM
        "NEW_YORK"."NEW_YORK"."TLC_YELLOW_TRIPS_2016"
    WHERE
        "pickup_latitude" IS NOT NULL AND
        "pickup_longitude" IS NOT NULL AND
        "dropoff_latitude" IS NOT NULL AND
        "dropoff_longitude" IS NOT NULL AND
        TO_TIMESTAMP_NTZ("pickup_datetime" / 1000000) >= '2016-01-01' AND
        TO_TIMESTAMP_NTZ("pickup_datetime" / 1000000) < '2017-01-01' AND
        ("dropoff_datetime" - "pickup_datetime") > 0
    GROUP BY
        ROUND("pickup_latitude", 3),
        ROUND("pickup_longitude", 3),
        ROUND("dropoff_latitude", 3),
        ROUND("dropoff_longitude", 3)
)
SELECT
    cbr."start_station_name"
FROM
    citi_bike_routes cbr
JOIN
    taxi_trip_durations ttd
ON
    cbr."start_latitude_3dp" = ttd."pickup_latitude_3dp" AND
    cbr."start_longitude_3dp" = ttd."pickup_longitude_3dp" AND
    cbr."end_latitude_3dp" = ttd."dropoff_latitude_3dp" AND
    cbr."end_longitude_3dp" = ttd."dropoff_longitude_3dp"
WHERE
    cbr."avg_bike_duration" < ttd."avg_taxi_duration"
ORDER BY
    cbr."avg_bike_duration" DESC NULLS LAST
LIMIT 1;