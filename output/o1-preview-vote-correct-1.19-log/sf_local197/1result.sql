WITH top_customers AS (
    SELECT "customer_id", SUM("amount") AS "total_payment"
    FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
    GROUP BY "customer_id"
    ORDER BY "total_payment" DESC
    LIMIT 10
),
customer_payment_differences AS (
    SELECT p."customer_id",
           TO_CHAR(TO_DATE(p."payment_date"), 'YYYY-MM') AS "payment_month",
           MAX(p."amount") AS "max_payment",
           MIN(p."amount") AS "min_payment",
           (MAX(p."amount") - MIN(p."amount")) AS "payment_difference"
    FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT" p
    JOIN top_customers tc ON p."customer_id" = tc."customer_id"
    GROUP BY p."customer_id", TO_CHAR(TO_DATE(p."payment_date"), 'YYYY-MM')
),
highest_differences AS (
    SELECT "customer_id", MAX("payment_difference") AS "highest_payment_difference"
    FROM customer_payment_differences
    GROUP BY "customer_id"
)
SELECT "customer_id", ROUND("highest_payment_difference", 4) AS "highest_payment_difference"
FROM highest_differences
ORDER BY "highest_payment_difference" DESC NULLS LAST
LIMIT 1;