WITH monthly_totals AS (
    SELECT
        "customer_id",
        strftime('%Y-%m', "payment_date") AS "month",
        SUM("amount") AS "total_amount"
    FROM
        "payment"
    GROUP BY
        "customer_id",
        "month"
),
monthly_changes AS (
    SELECT
        "customer_id",
        "month",
        "total_amount",
        "total_amount" - LAG("total_amount") OVER (
            PARTITION BY "customer_id"
            ORDER BY "month"
        ) AS "change"
    FROM
        monthly_totals
),
customer_avg_changes AS (
    SELECT
        "customer_id",
        ROUND(AVG(ABS("change")), 4) AS "avg_monthly_change"
    FROM
        monthly_changes
    WHERE
        "change" IS NOT NULL
    GROUP BY
        "customer_id"
)
SELECT
    c."first_name" AS "First_Name",
    c."last_name" AS "Last_Name"
FROM
    customer_avg_changes cac
    JOIN "customer" c ON cac."customer_id" = c."customer_id"
ORDER BY
    cac."avg_monthly_change" DESC
LIMIT 1;