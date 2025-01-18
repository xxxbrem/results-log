WITH parsed_transactions AS (
    SELECT
        "customer_id",
        TRY_TO_DATE("txn_date", 'YYYY-MM-DD') AS txn_date,
        "txn_amount"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CUSTOMER_TRANSACTIONS"
    WHERE
        TRY_TO_DATE("txn_date", 'YYYY-MM-DD') IS NOT NULL
),
daily_transactions AS (
    SELECT
        "customer_id",
        txn_date,
        SUM("txn_amount") AS daily_txn_amount
    FROM
        parsed_transactions
    GROUP BY
        "customer_id",
        txn_date
),
customer_daily_balances AS (
    SELECT
        "customer_id",
        txn_date,
        SUM(daily_txn_amount) OVER (
            PARTITION BY "customer_id"
            ORDER BY txn_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_balance
    FROM
        daily_transactions
),
adjusted_daily_balances AS (
    SELECT
        "customer_id",
        txn_date,
        CASE
            WHEN cumulative_balance < 0 THEN 0
            ELSE cumulative_balance
        END AS adjusted_balance
    FROM
        customer_daily_balances
),
customer_monthly_max_balances AS (
    SELECT
        "customer_id",
        TO_CHAR(txn_date, 'YYYY-MM') AS month,
        MAX(adjusted_balance) AS max_daily_balance
    FROM
        adjusted_daily_balances
    GROUP BY
        "customer_id",
        TO_CHAR(txn_date, 'YYYY-MM')
)
SELECT
    month AS "Month",
    ROUND(SUM(max_daily_balance), 4) AS "total_max_balances"
FROM
    customer_monthly_max_balances
GROUP BY
    month
ORDER BY
    month;