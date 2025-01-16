WITH monthly_counts AS (
    SELECT
        "company",
        EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ("trip_start_timestamp" / 1000000)) AS "month_num",
        COUNT(*) AS "trip_count"
    FROM CHICAGO.CHICAGO_TAXI_TRIPS.TAXI_TRIPS
    WHERE EXTRACT(YEAR FROM TO_TIMESTAMP_NTZ("trip_start_timestamp" / 1000000)) = 2018
    GROUP BY "company", "month_num"
),
monthly_diffs AS (
    SELECT
        "company",
        "month_num" AS "to_month_num",
        LAG("month_num") OVER (PARTITION BY "company" ORDER BY "month_num") AS "from_month_num",
        "trip_count" AS "to_trip_count",
        LAG("trip_count") OVER (PARTITION BY "company" ORDER BY "month_num") AS "from_trip_count",
        ("trip_count" - LAG("trip_count") OVER (PARTITION BY "company" ORDER BY "month_num")) AS "trip_count_diff"
    FROM monthly_counts
),
max_increases AS (
    SELECT
        "company",
        "trip_count_diff",
        "from_month_num",
        "to_month_num",
        TO_CHAR(DATE_FROM_PARTS(2018, "from_month_num", 1), 'MMMM') AS "from_month_name",
        TO_CHAR(DATE_FROM_PARTS(2018, "to_month_num", 1), 'MMMM') AS "to_month_name",
        ROW_NUMBER() OVER (PARTITION BY "company" ORDER BY "trip_count_diff" DESC) AS rn
    FROM monthly_diffs
    WHERE "trip_count_diff" > 0 AND "from_trip_count" IS NOT NULL
)
SELECT
    "company" AS company_name,
    "trip_count_diff" AS increase_in_trip_numbers,
    "from_month_num",
    "from_month_name",
    "to_month_num",
    "to_month_name"
FROM max_increases
WHERE rn = 1
ORDER BY "trip_count_diff" DESC NULLS LAST
LIMIT 3;