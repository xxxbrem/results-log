WITH monthly_totals AS (
  SELECT
    "customer_id",
    DATE_TRUNC('month', TRY_TO_TIMESTAMP("payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3')) AS "month",
    SUM("amount") AS "total_monthly_amount"
  FROM
    SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT
  GROUP BY
    "customer_id",
    DATE_TRUNC('month', TRY_TO_TIMESTAMP("payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3'))
),
monthly_changes AS (
  SELECT
    "customer_id",
    "month",
    "total_monthly_amount",
    "total_monthly_amount" - LAG("total_monthly_amount") OVER (PARTITION BY "customer_id" ORDER BY "month") AS "amount_change"
  FROM
    monthly_totals
),
average_changes AS (
  SELECT
    "customer_id",
    ROUND(AVG(ABS("amount_change")), 4) AS "avg_monthly_change"
  FROM
    monthly_changes
  WHERE
    "amount_change" IS NOT NULL
  GROUP BY
    "customer_id"
)
SELECT
  c."first_name",
  c."last_name"
FROM
  average_changes ac
  JOIN SQLITE_SAKILA.SQLITE_SAKILA.CUSTOMER c ON ac."customer_id" = c."customer_id"
ORDER BY
  ac."avg_monthly_change" DESC NULLS LAST
LIMIT 1;