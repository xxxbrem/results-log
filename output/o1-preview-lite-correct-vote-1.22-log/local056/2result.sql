WITH monthly_totals AS (
    SELECT
        customer_id,
        strftime('%Y-%m', "payment_date") AS year_month,
        SUM("amount") AS monthly_total
    FROM
        "payment"
    GROUP BY
        customer_id, year_month
),
monthly_changes AS (
    SELECT
        customer_id,
        monthly_total - LAG(monthly_total) OVER (
            PARTITION BY customer_id
            ORDER BY year_month
        ) AS monthly_change
    FROM
        monthly_totals
),
average_changes AS (
    SELECT
        customer_id,
        AVG(ABS(monthly_change)) AS avg_monthly_change
    FROM
        monthly_changes
    WHERE
        monthly_change IS NOT NULL
    GROUP BY
        customer_id
)
SELECT
    c."first_name" AS "First_Name",
    c."last_name" AS "Last_Name"
FROM
    average_changes ac
    INNER JOIN "customer" c ON ac.customer_id = c."customer_id"
ORDER BY
    ac.avg_monthly_change DESC
LIMIT 1;