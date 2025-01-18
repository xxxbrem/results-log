WITH monthly_payments AS (
  SELECT
    "customer_id",
    SUBSTR("payment_date", 1, 7) AS "payment_month",
    SUM("amount") AS "total_amount"
  FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
  GROUP BY "customer_id", "payment_month"
),
monthly_changes AS (
  SELECT
    "customer_id",
    "payment_month",
    "total_amount",
    LAG("total_amount") OVER (PARTITION BY "customer_id" ORDER BY "payment_month") AS "prev_total_amount",
    ("total_amount" - LAG("total_amount") OVER (PARTITION BY "customer_id" ORDER BY "payment_month")) AS "change_amount"
  FROM monthly_payments
),
average_changes AS (
  SELECT
    "customer_id",
    ROUND(AVG(ABS("change_amount")), 4) AS "avg_monthly_change"
  FROM monthly_changes
  WHERE "prev_total_amount" IS NOT NULL
  GROUP BY "customer_id"
)
SELECT
  c."first_name" || ' ' || c."last_name" AS "full_name"
FROM average_changes ac
JOIN "SQLITE_SAKILA"."SQLITE_SAKILA"."CUSTOMER" c ON ac."customer_id" = c."customer_id"
ORDER BY ac."avg_monthly_change" DESC NULLS LAST
LIMIT 1;