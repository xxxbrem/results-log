WITH parsed_trips AS (
  SELECT
    "company",
    CASE
      WHEN "trip_start_timestamp" >= 1e15 THEN TO_TIMESTAMP_NTZ("trip_start_timestamp" / 1000000)
      WHEN "trip_start_timestamp" >= 1e12 THEN TO_TIMESTAMP_NTZ("trip_start_timestamp" / 1000)
      ELSE TO_TIMESTAMP_NTZ("trip_start_timestamp")
    END AS parsed_timestamp
  FROM "CHICAGO"."CHICAGO_TAXI_TRIPS"."TAXI_TRIPS"
  WHERE "company" IS NOT NULL AND "trip_start_timestamp" IS NOT NULL
),
trips_2018 AS (
  SELECT
    "company",
    EXTRACT(MONTH FROM parsed_timestamp) AS month,
    COUNT(*) AS trip_count
  FROM parsed_trips
  WHERE EXTRACT(YEAR FROM parsed_timestamp) = 2018
  GROUP BY "company", EXTRACT(MONTH FROM parsed_timestamp)
),
monthly_increase AS (
  SELECT
    curr."company" AS company_name,
    prev.month AS from_month,
    curr.month AS to_month,
    (curr.trip_count - prev.trip_count) AS increase_in_trip_numbers
  FROM trips_2018 curr
  INNER JOIN trips_2018 prev
    ON curr."company" = prev."company" AND curr.month = prev.month + 1
)
SELECT
  company_name,
  increase_in_trip_numbers,
  from_month,
  to_month
FROM monthly_increase
WHERE increase_in_trip_numbers > 0
ORDER BY increase_in_trip_numbers DESC NULLS LAST
LIMIT 3;