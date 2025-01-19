WITH date_range AS (
  SELECT 
    DATE_TRUNC('MONTH', MIN(TO_DATE("txn_date", 'YYYY-MM-DD'))) AS min_month,
    DATE_TRUNC('MONTH', MAX(TO_DATE("txn_date", 'YYYY-MM-DD'))) AS max_month
  FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CUSTOMER_TRANSACTIONS"
),
months AS (
  SELECT min_month AS month_date
  FROM date_range
  UNION ALL
  SELECT DATEADD(MONTH, 1, month_date)
  FROM months
  WHERE month_date < (SELECT max_month FROM date_range)
),
customer_list AS (
  SELECT DISTINCT "customer_id"
  FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CUSTOMER_TRANSACTIONS"
),
customer_months AS (
  SELECT c."customer_id", m.month_date
  FROM customer_list c
  CROSS JOIN months m
),
customer_monthly_txn AS (
  SELECT
    "customer_id",
    DATE_TRUNC('MONTH', TO_DATE("txn_date", 'YYYY-MM-DD')) AS txn_month,
    SUM("txn_amount") AS monthly_amount
  FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CUSTOMER_TRANSACTIONS"
  GROUP BY "customer_id", DATE_TRUNC('MONTH', TO_DATE("txn_date", 'YYYY-MM-DD'))
),
customer_balances AS (
  SELECT
    cm."customer_id",
    cm.month_date,
    COALESCE(ct.monthly_amount, 0) AS monthly_change
  FROM customer_months cm
  LEFT JOIN customer_monthly_txn ct
    ON cm."customer_id" = ct."customer_id" AND cm.month_date = ct.txn_month
),
customer_balances_with_cumsum AS (
  SELECT
    "customer_id",
    month_date,
    EXTRACT(YEAR FROM month_date) AS year,
    EXTRACT(MONTH FROM month_date) AS month,
    ROUND(monthly_change, 4) AS monthly_change,
    ROUND(SUM(monthly_change) OVER (PARTITION BY "customer_id" ORDER BY month_date), 4) AS closing_balance
  FROM customer_balances
)
SELECT
  "customer_id",
  year,
  month,
  closing_balance,
  monthly_change
FROM customer_balances_with_cumsum
ORDER BY "customer_id", year, month;