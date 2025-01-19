WITH TopBikeRoutes AS (
    SELECT 
        "start_station_id", 
        "end_station_id",
        "start_station_name",
        ROUND("start_station_latitude", 3) AS start_lat,
        ROUND("start_station_longitude", 3) AS start_lon,
        ROUND("end_station_latitude", 3) AS end_lat,
        ROUND("end_station_longitude", 3) AS end_lon,
        COUNT(*) AS trip_count,
        AVG("tripduration") AS avg_bike_duration
    FROM 
        NEW_YORK.NEW_YORK.CITIBIKE_TRIPS
    WHERE 
        EXTRACT(year FROM TO_TIMESTAMP_NTZ("starttime" / 1000000)) = 2016
        AND "start_station_latitude" IS NOT NULL
        AND "start_station_longitude" IS NOT NULL
        AND "end_station_latitude" IS NOT NULL
        AND "end_station_longitude" IS NOT NULL
    GROUP BY 
        "start_station_id", 
        "end_station_id",
        "start_station_name",
        start_lat,
        start_lon,
        end_lat,
        end_lon
    ORDER BY 
        trip_count DESC
    LIMIT 20
),
TaxiTrips AS (
    SELECT 
        ROUND("pickup_latitude", 3) AS pickup_lat,
        ROUND("pickup_longitude", 3) AS pickup_lon,
        ROUND("dropoff_latitude", 3) AS dropoff_lat,
        ROUND("dropoff_longitude", 3) AS dropoff_lon,
        AVG(
            DATEDIFF(
                'second', 
                TO_TIMESTAMP_NTZ("pickup_datetime" / 1000000), 
                TO_TIMESTAMP_NTZ("dropoff_datetime" / 1000000)
            )
        ) AS avg_taxi_duration
    FROM 
        NEW_YORK.NEW_YORK.TLC_YELLOW_TRIPS_2016
    WHERE 
        EXTRACT(year FROM TO_TIMESTAMP_NTZ("pickup_datetime" / 1000000)) = 2016
        AND "pickup_latitude" IS NOT NULL
        AND "pickup_longitude" IS NOT NULL
        AND "dropoff_latitude" IS NOT NULL
        AND "dropoff_longitude" IS NOT NULL
        AND ABS("pickup_latitude") > 0.0
        AND ABS("pickup_longitude") > 0.0
        AND ABS("dropoff_latitude") > 0.0
        AND ABS("dropoff_longitude") > 0.0
    GROUP BY 
        pickup_lat,
        pickup_lon,
        dropoff_lat,
        dropoff_lon
)
SELECT 
    tbr."start_station_name"
FROM 
    TopBikeRoutes tbr
    INNER JOIN TaxiTrips tt
    ON tbr.start_lat = tt.pickup_lat
    AND tbr.start_lon = tt.pickup_lon
    AND tbr.end_lat = tt.dropoff_lat
    AND tbr.end_lon = tt.dropoff_lon
WHERE 
    tbr.avg_bike_duration < tt.avg_taxi_duration
ORDER BY 
    tbr.avg_bike_duration DESC NULLS LAST
LIMIT 1;