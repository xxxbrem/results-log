WITH TripsWithMinutes AS (
    SELECT
        "trip_seconds",
        ROUND("trip_seconds" / 60.0) AS "trip_minutes",
        "fare"
    FROM CHICAGO.CHICAGO_TAXI_TRIPS.TAXI_TRIPS
    WHERE "trip_seconds" IS NOT NULL
      AND "trip_seconds" > 0
      AND "fare" IS NOT NULL
),
FilteredTrips AS (
    SELECT *
    FROM TripsWithMinutes
    WHERE "trip_minutes" BETWEEN 1 AND 50
),
TripWithQuantile AS (
    SELECT
        *,
        NTILE(10) OVER (ORDER BY "trip_minutes") AS "quantile"
    FROM FilteredTrips
)
SELECT
    'Quantile ' || "quantile" || ' (' || MIN("trip_minutes") || '-' || MAX("trip_minutes") || ' minutes)' AS "Duration_Range",
    COUNT(*) AS "Total_Trips",
    ROUND(AVG("fare"), 4) AS "Average_Fare"
FROM TripWithQuantile
GROUP BY "quantile"
ORDER BY "quantile";