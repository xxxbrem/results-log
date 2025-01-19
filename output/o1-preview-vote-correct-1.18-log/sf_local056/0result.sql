WITH monthly_payments AS (
  SELECT
    "customer_id",
    EXTRACT(YEAR FROM TRY_TO_DATE("payment_date")) AS "year",
    EXTRACT(MONTH FROM TRY_TO_DATE("payment_date")) AS "month",
    SUM("amount") AS "monthly_amount"
  FROM SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT
  GROUP BY "customer_id", "year", "month"
),
monthly_changes AS (
  SELECT
    "customer_id",
    "year",
    "month",
    "monthly_amount",
    LAG("monthly_amount") OVER (
      PARTITION BY "customer_id" 
      ORDER BY "year", "month"
    ) AS "prev_monthly_amount",
    "monthly_amount" - LAG("monthly_amount") OVER (
      PARTITION BY "customer_id" 
      ORDER BY "year", "month"
    ) AS "monthly_change"
  FROM monthly_payments
),
customer_avg_changes AS (
  SELECT
    "customer_id",
    ROUND(AVG(ABS("monthly_change")), 4) AS "avg_monthly_change"
  FROM monthly_changes
  WHERE "monthly_change" IS NOT NULL
  GROUP BY "customer_id"
),
highest_avg_change_customer AS (
  SELECT
    "customer_id"
  FROM customer_avg_changes
  ORDER BY "avg_monthly_change" DESC NULLS LAST
  LIMIT 1
)
SELECT
  CONCAT(c."first_name", ' ', c."last_name") AS "Full_Name"
FROM highest_avg_change_customer h
JOIN SQLITE_SAKILA.SQLITE_SAKILA.CUSTOMER c 
  ON h."customer_id" = c."customer_id";