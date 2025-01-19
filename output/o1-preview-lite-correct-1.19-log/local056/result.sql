WITH "monthly_totals" AS (
    SELECT
        "customer_id",
        STRFTIME('%Y-%m', "payment_date") AS "payment_month",
        SUM("amount") AS "monthly_total"
    FROM "payment"
    GROUP BY "customer_id", "payment_month"
),
"monthly_changes" AS (
    SELECT
        t1."customer_id",
        t1."monthly_total" - COALESCE(t0."monthly_total", 0) AS "monthly_change"
    FROM "monthly_totals" t1
    LEFT JOIN "monthly_totals" t0
        ON t1."customer_id" = t0."customer_id"
        AND t0."payment_month" = STRFTIME('%Y-%m', DATE(t1."payment_month" || '-01', '-1 month'))
),
"average_changes" AS (
    SELECT
        "customer_id",
        ROUND(AVG(ABS("monthly_change")), 4) AS "avg_monthly_change"
    FROM "monthly_changes"
    GROUP BY "customer_id"
)
SELECT
    c."first_name" || ' ' || c."last_name" AS "Name"
FROM "average_changes" ac
JOIN "customer" c ON c."customer_id" = ac."customer_id"
ORDER BY ac."avg_monthly_change" DESC
LIMIT 1;