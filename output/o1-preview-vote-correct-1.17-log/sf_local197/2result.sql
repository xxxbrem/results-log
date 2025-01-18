WITH top_customers AS (
  SELECT "customer_id", SUM("amount") AS "total_payments"
  FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
  GROUP BY "customer_id"
  ORDER BY "total_payments" DESC
  LIMIT 10
),
payments_per_month AS (
  SELECT p."customer_id",
    DATE_TRUNC('month', TO_TIMESTAMP_NTZ(p."payment_date")) AS "month",
    SUM(p."amount") AS "monthly_total"
  FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT" p
  JOIN top_customers tc ON p."customer_id" = tc."customer_id"
  GROUP BY p."customer_id", DATE_TRUNC('month', TO_TIMESTAMP_NTZ(p."payment_date"))
),
customer_payment_diff AS (
  SELECT "customer_id",
    MAX("monthly_total") AS "max_monthly_total",
    MIN("monthly_total") AS "min_monthly_total",
    MAX("monthly_total") - MIN("monthly_total") AS "payment_difference"
  FROM payments_per_month
  GROUP BY "customer_id"
),
max_difference AS (
  SELECT "customer_id", "payment_difference"
  FROM customer_payment_diff
  ORDER BY "payment_difference" DESC NULLS LAST
  LIMIT 1
)
SELECT cd."customer_id",
  c."first_name" || ' ' || c."last_name" AS "customer_name",
  ROUND(cd."payment_difference", 4) AS "highest_payment_difference"
FROM max_difference cd
JOIN "SQLITE_SAKILA"."SQLITE_SAKILA"."CUSTOMER" c ON cd."customer_id" = c."customer_id";