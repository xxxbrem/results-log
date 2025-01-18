WITH monthly_totals AS (
    SELECT 
        "customer_id",
        EXTRACT(YEAR FROM TO_TIMESTAMP("payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3')) AS "year",
        EXTRACT(MONTH FROM TO_TIMESTAMP("payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3')) AS "month",
        SUM("amount") AS "monthly_total_amount"
    FROM SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT
    GROUP BY "customer_id", "year", "month"
),
monthly_changes AS (
    SELECT
        "customer_id",
        "year",
        "month",
        "monthly_total_amount",
        "monthly_total_amount" - LAG("monthly_total_amount") OVER (
            PARTITION BY "customer_id" ORDER BY "year", "month"
        ) AS "monthly_change"
    FROM monthly_totals
),
average_changes AS (
    SELECT
        "customer_id",
        ROUND(AVG(ABS("monthly_change")), 4) AS "avg_monthly_change"
    FROM monthly_changes
    WHERE "monthly_change" IS NOT NULL
    GROUP BY "customer_id"
)
SELECT c."customer_id", c."first_name", c."last_name"
FROM average_changes a
JOIN SQLITE_SAKILA.SQLITE_SAKILA.CUSTOMER c ON a."customer_id" = c."customer_id"
ORDER BY a."avg_monthly_change" DESC NULLS LAST
LIMIT 1;