WITH top_customers AS (
  SELECT
    "customer_id",
    SUM("amount") AS "total_payment"
  FROM
    SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT
  GROUP BY
    "customer_id"
  ORDER BY
    "total_payment" DESC NULLS LAST
  LIMIT
    10
),
customer_monthly_payments AS (
  SELECT
    p."customer_id",
    DATE_TRUNC('month', TO_TIMESTAMP(p."payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3')) AS "payment_month",
    ROUND(SUM(p."amount")::numeric, 4) AS "monthly_total"
  FROM
    SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT p
    JOIN top_customers t ON p."customer_id" = t."customer_id"
  GROUP BY
    p."customer_id",
    "payment_month"
),
customer_payment_differences AS (
  SELECT
    "customer_id",
    MAX("monthly_total") - MIN("monthly_total") AS "payment_difference"
  FROM
    customer_monthly_payments
  GROUP BY
    "customer_id"
)
SELECT
  "customer_id",
  ROUND("payment_difference", 2) AS "Highest_Payment_Difference"
FROM
  customer_payment_differences
ORDER BY
  "payment_difference" DESC NULLS LAST
LIMIT
  1;