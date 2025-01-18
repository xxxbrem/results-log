WITH monthly_payments AS (
    SELECT
        "customer_id",
        TO_CHAR(TRY_TO_TIMESTAMP("payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3'), 'YYYY-MM') AS "year_month",
        SUM("amount") AS "monthly_total"
    FROM
        "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
    GROUP BY
        "customer_id",
        "year_month"
),
monthly_changes AS (
    SELECT
        "customer_id",
        "year_month",
        "monthly_total",
        "monthly_total" - LAG("monthly_total") OVER (
            PARTITION BY "customer_id"
            ORDER BY TO_DATE("year_month", 'YYYY-MM')
        ) AS "change"
    FROM
        monthly_payments
),
average_changes AS (
    SELECT
        "customer_id",
        AVG(ABS("change")) AS "average_monthly_change"
    FROM
        monthly_changes
    WHERE
        "change" IS NOT NULL
    GROUP BY
        "customer_id"
)
SELECT
    c."first_name" || ' ' || c."last_name" AS "customer_full_name",
    ROUND(ac."average_monthly_change", 4) AS "average_monthly_change"
FROM
    average_changes ac
JOIN
    "SQLITE_SAKILA"."SQLITE_SAKILA"."CUSTOMER" c ON ac."customer_id" = c."customer_id"
ORDER BY
    ac."average_monthly_change" DESC NULLS LAST
LIMIT 1;