WITH MonthlyTrips AS (
    SELECT
        "company",
        MONTH(TO_TIMESTAMP_LTZ("trip_start_timestamp" / 1e6)) AS "month",
        COUNT(*) AS "trip_count"
    FROM "CHICAGO"."CHICAGO_TAXI_TRIPS"."TAXI_TRIPS"
    WHERE "trip_start_timestamp" IS NOT NULL
        AND YEAR(TO_TIMESTAMP_LTZ("trip_start_timestamp" / 1e6)) = 2018
    GROUP BY "company",
             MONTH(TO_TIMESTAMP_LTZ("trip_start_timestamp" / 1e6))
),
MonthlyTripsWithLag AS (
    SELECT
        "company",
        "month",
        "trip_count",
        LAG("month") OVER (PARTITION BY "company" ORDER BY "month") AS "prev_month",
        LAG("trip_count") OVER (PARTITION BY "company" ORDER BY "month") AS "prev_trip_count"
        FROM MonthlyTrips
)
SELECT
    "company" AS "Company",
    "prev_month" AS "Start_Month_Num",
    "month" AS "End_Month_Num",
    ("trip_count" - "prev_trip_count") AS "Trip_Increase"
FROM MonthlyTripsWithLag
WHERE "prev_trip_count" IS NOT NULL
    AND ("trip_count" - "prev_trip_count") > 0
ORDER BY "Trip_Increase" DESC NULLS LAST
LIMIT 3;