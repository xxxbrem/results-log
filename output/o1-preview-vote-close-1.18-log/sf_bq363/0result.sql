WITH trip_data AS (
    SELECT
        ROUND("trip_seconds" / 60.0) AS "trip_duration_in_minutes",
        "fare",
        NTILE(10) OVER (ORDER BY ROUND("trip_seconds" / 60.0)) AS "Duration_Quantile"
    FROM CHICAGO.CHICAGO_TAXI_TRIPS.TAXI_TRIPS
    WHERE 
        "trip_seconds" IS NOT NULL 
        AND "trip_seconds" > 0 
        AND ROUND("trip_seconds" / 60.0) BETWEEN 1 AND 50 
        AND "fare" IS NOT NULL 
        AND "fare" > 0
)
SELECT
    'Quantile ' || CAST("Duration_Quantile" AS VARCHAR) AS "Duration_Quantile",
    COUNT(*) AS "Total_Trips",
    ROUND(AVG("fare"), 4) AS "Average_Fare"
FROM trip_data
GROUP BY "Duration_Quantile"
ORDER BY "Duration_Quantile";