WITH monthly_trips AS (
  SELECT
    "company",
    DATE_TRUNC('month', TO_TIMESTAMP("trip_start_timestamp" / 1e6)) AS "month_start",
    COUNT(*) AS "trip_count"
  FROM
    CHICAGO.CHICAGO_TAXI_TRIPS.TAXI_TRIPS
  WHERE
    YEAR(TO_TIMESTAMP("trip_start_timestamp" / 1e6)) = 2018
  GROUP BY
    "company",
    DATE_TRUNC('month', TO_TIMESTAMP("trip_start_timestamp" / 1e6))
),
monthly_trips_with_diff AS (
  SELECT
    "company",
    "month_start",
    "trip_count",
    LAG("trip_count") OVER (
      PARTITION BY "company"
      ORDER BY "month_start"
    ) AS "prev_trip_count",
    "trip_count" - LAG("trip_count") OVER (
      PARTITION BY "company"
      ORDER BY "month_start"
    ) AS "trip_count_diff"
  FROM
    monthly_trips
)
SELECT
  "company" AS "Company",
  MAX("trip_count_diff") AS "Increase_in_Trip_Numbers"
FROM
  monthly_trips_with_diff
WHERE
  "trip_count_diff" IS NOT NULL
GROUP BY
  "company"
ORDER BY
  "Increase_in_Trip_Numbers" DESC NULLS LAST
LIMIT 3;