WITH monthly_totals AS (
    SELECT
        "customer_id",
        DATE_TRUNC('month', TO_TIMESTAMP_NTZ("payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3')) AS "payment_month",
        SUM("amount") AS "total_amount"
    FROM
        SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT
    GROUP BY
        "customer_id",
        "payment_month"
),
monthly_changes AS (
    SELECT
        "customer_id",
        "payment_month",
        "total_amount",
        LAG("total_amount") OVER (
            PARTITION BY "customer_id"
            ORDER BY "payment_month"
        ) AS "previous_total_amount",
        "total_amount" - LAG("total_amount") OVER (
            PARTITION BY "customer_id"
            ORDER BY "payment_month"
        ) AS "amount_change"
    FROM
        monthly_totals
),
customer_changes AS (
    SELECT
        "customer_id",
        ROUND(AVG(ABS("amount_change")), 4) AS "avg_monthly_change"
    FROM
        monthly_changes
    WHERE
        "amount_change" IS NOT NULL
    GROUP BY
        "customer_id"
)
SELECT
    c."first_name" || ' ' || c."last_name" AS "customer_full_name"
FROM
    customer_changes cc
    JOIN SQLITE_SAKILA.SQLITE_SAKILA.CUSTOMER c ON cc."customer_id" = c."customer_id"
ORDER BY
    cc."avg_monthly_change" DESC NULLS LAST
LIMIT 1;