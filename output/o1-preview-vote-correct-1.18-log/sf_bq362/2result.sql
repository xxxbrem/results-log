WITH monthly_trips AS (
    SELECT
        "company",
        EXTRACT(MONTH FROM TO_TIMESTAMP("trip_start_timestamp", 6)) AS "month",
        COUNT(*) AS "trip_count"
    FROM CHICAGO.CHICAGO_TAXI_TRIPS.TAXI_TRIPS
    WHERE EXTRACT(YEAR FROM TO_TIMESTAMP("trip_start_timestamp", 6)) = 2018
    GROUP BY "company", "month"
),
monthly_increases AS (
    SELECT
        "company",
        "month",
        "trip_count",
        "trip_count" - LAG("trip_count") OVER (PARTITION BY "company" ORDER BY "month") AS "monthly_increase"
    FROM monthly_trips
)
SELECT
    "company" AS "Company",
    MAX("monthly_increase") AS "Increase_in_trips"
FROM monthly_increases
WHERE "monthly_increase" IS NOT NULL
GROUP BY "company"
ORDER BY "Increase_in_trips" DESC NULLS LAST
LIMIT 3;