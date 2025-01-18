WITH daily_transactions AS (
   SELECT
       "customer_id",
       TO_DATE("txn_date", 'YYYY-MM-DD') AS "txn_date",
       SUM("txn_amount") AS "daily_txn_amount"
   FROM
       BANK_SALES_TRADING.BANK_SALES_TRADING.CUSTOMER_TRANSACTIONS
   GROUP BY
       "customer_id",
       TO_DATE("txn_date", 'YYYY-MM-DD')
),
daily_balances AS (
   SELECT
       "customer_id",
       "txn_date",
       SUM("daily_txn_amount") OVER (
           PARTITION BY "customer_id" 
           ORDER BY "txn_date" 
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS "cumulative_balance"
   FROM
       daily_transactions
),
daily_balances_non_negative AS (
   SELECT
       "customer_id",
       "txn_date",
       GREATEST("cumulative_balance", 0) AS "balance"
   FROM
       daily_balances
),
customer_monthly_max_balances AS (
   SELECT
       "customer_id",
       TO_VARCHAR(DATE_TRUNC('month', "txn_date"), 'YYYY-MM') AS "Month",
       MAX("balance") AS "max_daily_balance"
   FROM
       daily_balances_non_negative
   GROUP BY
       "customer_id",
       TO_VARCHAR(DATE_TRUNC('month', "txn_date"), 'YYYY-MM')
),
monthly_total_max_balances AS (
   SELECT
       "Month",
       SUM("max_daily_balance") AS "Total_Max_Daily_Balance"
   FROM
       customer_monthly_max_balances
   GROUP BY
       "Month"
   ORDER BY
       "Month"
)
SELECT
   "Month",
   TO_DECIMAL("Total_Max_Daily_Balance", 20, 4) AS "Total_Max_Daily_Balance"
FROM
   monthly_total_max_balances;