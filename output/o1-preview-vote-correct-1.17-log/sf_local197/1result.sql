WITH top_customers AS (
    SELECT "customer_id", SUM("amount") AS "total_amount"
    FROM SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT
    GROUP BY "customer_id"
    ORDER BY "total_amount" DESC NULLS LAST
    LIMIT 10
),
monthly_payment_diff AS (
    SELECT 
        p."customer_id",
        DATE_TRUNC('MONTH', TO_TIMESTAMP(p."payment_date", 'YYYY-MM-DD HH24:MI:SS.FF')) AS "payment_month",
        MAX(p."amount") - MIN(p."amount") AS "payment_difference"
    FROM SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT p
    WHERE p."customer_id" IN (SELECT "customer_id" FROM top_customers)
    GROUP BY p."customer_id", "payment_month"
),
customer_max_diff AS (
    SELECT 
        "customer_id",
        MAX("payment_difference") AS "highest_payment_difference"
    FROM monthly_payment_diff
    GROUP BY "customer_id"
)
SELECT 
    c."customer_id",
    c."first_name" || ' ' || c."last_name" AS "customer_name",
    ROUND(cmd."highest_payment_difference", 2) AS "highest_payment_difference"
FROM customer_max_diff cmd
JOIN SQLITE_SAKILA.SQLITE_SAKILA.CUSTOMER c ON cmd."customer_id" = c."customer_id"
ORDER BY cmd."highest_payment_difference" DESC NULLS LAST
LIMIT 1;