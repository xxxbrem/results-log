WITH top_customers AS (
    SELECT "customer_id", SUM("amount") AS "total_amount"
    FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
    GROUP BY "customer_id"
    ORDER BY "total_amount" DESC
    LIMIT 10
),
monthly_totals AS (
    SELECT p."customer_id", SUBSTRING(p."payment_date", 1, 7) AS "year_month", SUM(p."amount") AS "monthly_total"
    FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT" p
    WHERE p."customer_id" IN (SELECT "customer_id" FROM top_customers)
    GROUP BY p."customer_id", "year_month"
),
customer_diff AS (
    SELECT "customer_id", MAX("monthly_total") AS "max_monthly", MIN("monthly_total") AS "min_monthly", 
           (MAX("monthly_total") - MIN("monthly_total")) AS "payment_diff"
    FROM monthly_totals
    GROUP BY "customer_id"
)
SELECT CONCAT(c."first_name", ' ', c."last_name") AS "customer_name", 
       ROUND(cd."payment_diff", 2) AS "highest_payment_difference"
FROM customer_diff cd
JOIN "SQLITE_SAKILA"."SQLITE_SAKILA"."CUSTOMER" c ON cd."customer_id" = c."customer_id"
ORDER BY cd."payment_diff" DESC NULLS LAST
LIMIT 1;