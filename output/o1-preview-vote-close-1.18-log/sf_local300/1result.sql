WITH adjusted_transactions AS (
    SELECT
        "customer_id",
        TRY_TO_DATE("txn_date", 'YYYY-MM-DD') AS "txn_date",
        CASE
            WHEN "txn_type" = 'deposit' THEN COALESCE("txn_amount", 0)
            WHEN "txn_type" IN ('withdrawal', 'purchase') THEN -1 * COALESCE("txn_amount", 0)
            ELSE 0
        END AS "adjusted_txn_amount"
    FROM
        BANK_SALES_TRADING.BANK_SALES_TRADING.CUSTOMER_TRANSACTIONS
    WHERE
        TRY_TO_DATE("txn_date", 'YYYY-MM-DD') IS NOT NULL
        AND "txn_amount" IS NOT NULL
),
daily_balances AS (
    SELECT
        "customer_id",
        "txn_date",
        SUM("adjusted_txn_amount") AS "daily_balance"
    FROM
        adjusted_transactions
    GROUP BY
        "customer_id",
        "txn_date"
),
non_negative_daily_balances AS (
    SELECT
        "customer_id",
        "txn_date",
        GREATEST("daily_balance", 0) AS "non_negative_daily_balance"
    FROM
        daily_balances
),
max_daily_balance_per_customer AS (
    SELECT
        "customer_id",
        TO_CHAR("txn_date", 'YYYY-MM') AS "Month",
        MAX("non_negative_daily_balance") AS "Max_Daily_Balance"
    FROM
        non_negative_daily_balances
    GROUP BY
        "customer_id",
        TO_CHAR("txn_date", 'YYYY-MM')
),
monthly_total_highest_daily_balance AS (
    SELECT
        "Month",
        SUM("Max_Daily_Balance") AS "Total_Highest_Daily_Balance"
    FROM
        max_daily_balance_per_customer
    GROUP BY
        "Month"
)
SELECT
    "Month",
    ROUND("Total_Highest_Daily_Balance", 4) AS "Total_Highest_Daily_Balance"
FROM
    monthly_total_highest_daily_balance
ORDER BY
    "Month";