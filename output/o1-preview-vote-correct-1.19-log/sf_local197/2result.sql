WITH top_customers AS (
    SELECT "customer_id", SUM("amount") AS "total_payment"
    FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
    GROUP BY "customer_id"
    ORDER BY "total_payment" DESC NULLS LAST
    LIMIT 10
),
payments_with_date AS (
    SELECT "customer_id",
           TO_TIMESTAMP("payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3') AS "payment_date_parsed",
           EXTRACT(YEAR FROM "payment_date_parsed") AS "year",
           EXTRACT(MONTH FROM "payment_date_parsed") AS "month",
           "amount"
    FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
    WHERE "customer_id" IN (SELECT "customer_id" FROM top_customers)
),
monthly_differences AS (
    SELECT "customer_id", "year", "month",
           MAX("amount") - MIN("amount") AS "payment_difference"
    FROM payments_with_date
    GROUP BY "customer_id", "year", "month"
),
customer_max_differences AS (
    SELECT "customer_id", MAX("payment_difference") AS "max_payment_difference"
    FROM monthly_differences
    GROUP BY "customer_id"
)
SELECT "customer_id", ROUND("max_payment_difference", 4) AS "highest_payment_difference"
FROM customer_max_differences
ORDER BY "highest_payment_difference" DESC NULLS LAST
LIMIT 1;