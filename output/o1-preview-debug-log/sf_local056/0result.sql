WITH monthly_totals AS (
    SELECT
        "customer_id",
        SUBSTRING("payment_date", 1, 7) AS "year_month",
        SUM("amount") AS "monthly_total"
    FROM SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT
    GROUP BY "customer_id", "year_month"
),
monthly_changes AS (
    SELECT
        "customer_id",
        "year_month",
        "monthly_total",
        LAG("monthly_total") OVER (
            PARTITION BY "customer_id" 
            ORDER BY "year_month"
        ) AS "prev_month_total",
        "monthly_total" - LAG("monthly_total") OVER (
            PARTITION BY "customer_id" 
            ORDER BY "year_month"
        ) AS "monthly_change"
    FROM monthly_totals
),
average_changes AS (
    SELECT
        "customer_id",
        AVG("monthly_change") AS "average_monthly_change"
    FROM monthly_changes
    WHERE "monthly_change" IS NOT NULL
    GROUP BY "customer_id"
),
max_average_change AS (
    SELECT
        "customer_id",
        "average_monthly_change"
    FROM average_changes
    ORDER BY "average_monthly_change" DESC NULLS LAST
    LIMIT 1
),
customer_full_name AS (
    SELECT
        "customer_id",
        CONCAT("first_name", ' ', "last_name") AS "full_name"
    FROM SQLITE_SAKILA.SQLITE_SAKILA.CUSTOMER
)
SELECT
    c."full_name",
    ROUND(m."average_monthly_change", 4) AS "average_monthly_change"
FROM
    max_average_change AS m
    JOIN customer_full_name AS c 
    ON m."customer_id" = c."customer_id";