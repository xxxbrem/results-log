WITH
-- Parse trip start times and filter to year 2018
trip_data AS (
    SELECT
        "company",
        CASE
            WHEN "trip_start_timestamp" >= 1e15 THEN TO_TIMESTAMP_NTZ("trip_start_timestamp" / 1000000)
            WHEN "trip_start_timestamp" >= 1e12 THEN TO_TIMESTAMP_NTZ("trip_start_timestamp" / 1000)
            ELSE TO_TIMESTAMP_NTZ("trip_start_timestamp")
        END AS trip_start_time
    FROM CHICAGO.CHICAGO_TAXI_TRIPS.TAXI_TRIPS
    WHERE "trip_start_timestamp" IS NOT NULL AND "company" IS NOT NULL AND "company" != ''
),
-- Extract month and filter to trips in 2018
trips_2018 AS (
    SELECT
        "company",
        EXTRACT(MONTH FROM trip_start_time) AS month
    FROM trip_data
    WHERE EXTRACT(YEAR FROM trip_start_time) = 2018
),
-- Count trips per company per month
monthly_trip_counts AS (
    SELECT
        "company",
        month,
        COUNT(*) AS trip_count
    FROM trips_2018
    GROUP BY "company", month
),
-- Calculate month-over-month increases
monthly_trip_counts_with_diff AS (
    SELECT
        "company",
        month,
        trip_count,
        trip_count - LAG(trip_count) OVER (PARTITION BY "company" ORDER BY month) AS increase,
        LAG(month) OVER (PARTITION BY "company" ORDER BY month) AS prev_month
    FROM monthly_trip_counts
),
-- Find the maximum increase per company
company_max_increase AS (
    SELECT
        "company",
        increase AS max_increase,
        prev_month AS from_month_num,
        month AS to_month_num
    FROM (
        SELECT
            monthly_trip_counts_with_diff.*,
            ROW_NUMBER() OVER (PARTITION BY "company" ORDER BY increase DESC NULLS LAST) AS rn
        FROM monthly_trip_counts_with_diff
        WHERE increase IS NOT NULL
    )
    WHERE rn = 1
)
-- Select the top three companies with the largest increases
SELECT
    "company" AS company_name,
    max_increase,
    from_month_num,
    TO_CHAR(DATE_FROM_PARTS(2018, from_month_num, 1), 'Mon') AS from_month,
    to_month_num,
    TO_CHAR(DATE_FROM_PARTS(2018, to_month_num, 1), 'Mon') AS to_month
FROM company_max_increase
ORDER BY max_increase DESC NULLS LAST
LIMIT 3;