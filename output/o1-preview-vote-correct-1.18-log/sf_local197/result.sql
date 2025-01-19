WITH top_customers AS (
  SELECT "customer_id"
  FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
  GROUP BY "customer_id"
  ORDER BY SUM("amount") DESC NULLS LAST
  LIMIT 10
),
monthly_totals AS (
  SELECT
    p."customer_id",
    SUBSTR(p."payment_date", 1, 7) AS "payment_month",
    SUM(p."amount") AS "monthly_amount"
  FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT" p
  WHERE p."customer_id" IN (SELECT "customer_id" FROM top_customers)
  GROUP BY p."customer_id", SUBSTR(p."payment_date", 1, 7)
),
customer_differences AS (
  SELECT
    "customer_id",
    MAX("monthly_amount") - MIN("monthly_amount") AS "payment_difference"
  FROM monthly_totals
  GROUP BY "customer_id"
)
SELECT
  ROUND(MAX("payment_difference"), 2) AS "Highest_payment_difference"
FROM customer_differences;