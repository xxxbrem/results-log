WITH top_customers AS (
    SELECT "customer_id", SUM("amount") AS "total_payment"
    FROM SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT
    GROUP BY "customer_id"
    ORDER BY "total_payment" DESC NULLS LAST
    LIMIT 10
),
monthly_totals AS (
    SELECT p."customer_id", DATE_TRUNC('month', TO_TIMESTAMP(p."payment_date")) AS "month", SUM(p."amount") AS "monthly_total"
    FROM SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT p
    WHERE p."customer_id" IN (SELECT "customer_id" FROM top_customers)
    GROUP BY p."customer_id", DATE_TRUNC('month', TO_TIMESTAMP(p."payment_date"))
),
customer_differences AS (
    SELECT "customer_id",
       MAX("monthly_total") AS "max_monthly_total",
       MIN("monthly_total") AS "min_monthly_total",
       MAX("monthly_total") - MIN("monthly_total") AS "payment_difference"
    FROM monthly_totals
    GROUP BY "customer_id"
),
max_difference AS (
    SELECT "customer_id", ROUND("payment_difference", 2) AS "Highest_Payment_Difference"
    FROM customer_differences
    ORDER BY "payment_difference" DESC NULLS LAST
    LIMIT 1
)
SELECT "customer_id" AS "Customer_ID", "Highest_Payment_Difference"
FROM max_difference;