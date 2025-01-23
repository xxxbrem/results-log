SELECT c."first_name" AS "First_Name", c."last_name" AS "Last_Name"
FROM (
    SELECT "customer_id", ROUND(AVG("monthly_change"), 4) AS "avg_monthly_change"
    FROM (
        SELECT "customer_id", "month", "monthly_total",
               "monthly_total" - LAG("monthly_total") OVER (PARTITION BY "customer_id" ORDER BY "month") AS "monthly_change"
        FROM (
            SELECT "customer_id", STRFTIME('%Y-%m', "payment_date") AS "month", SUM("amount") AS "monthly_total"
            FROM "payment"
            GROUP BY "customer_id", "month"
        )
    )
    WHERE "monthly_change" IS NOT NULL
    GROUP BY "customer_id"
    ORDER BY "avg_monthly_change" DESC
    LIMIT 1
) AS t
JOIN "customer" AS c ON t."customer_id" = c."customer_id";