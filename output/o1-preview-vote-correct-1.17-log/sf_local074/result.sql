WITH customer_list AS (
    SELECT DISTINCT "customer_id"
    FROM BANK_SALES_TRADING.BANK_SALES_TRADING.CUSTOMER_TRANSACTIONS
),
dates AS (
    SELECT 
        MIN(DATE_TRUNC('month', TO_DATE("txn_date", 'YYYY-MM-DD'))) AS start_month,
        MAX(DATE_TRUNC('month', TO_DATE("txn_date", 'YYYY-MM-DD'))) AS end_month
    FROM BANK_SALES_TRADING.BANK_SALES_TRADING.CUSTOMER_TRANSACTIONS
),
month_sequence AS (
    SELECT start_month AS "month"
    FROM dates
    UNION ALL
    SELECT DATEADD(month, 1, "month")
    FROM month_sequence
    WHERE "month" < (SELECT end_month FROM dates)
),
month_list AS (
    SELECT TO_CHAR("month", 'YYYY-MM') AS "month"
    FROM month_sequence
),
customer_months AS (
    SELECT c."customer_id", m."month"
    FROM customer_list c
    CROSS JOIN month_list m
),
monthly_transactions AS (
    SELECT
        "customer_id",
        TO_CHAR(DATE_TRUNC('month', TO_DATE("txn_date", 'YYYY-MM-DD')), 'YYYY-MM') AS "month",
        SUM(
            CASE
                WHEN "txn_type" = 'deposit' THEN "txn_amount"
                WHEN "txn_type" IN ('withdrawal', 'purchase') THEN - "txn_amount"
                ELSE 0
            END
        ) AS "monthly_change"
    FROM BANK_SALES_TRADING.BANK_SALES_TRADING.CUSTOMER_TRANSACTIONS
    GROUP BY "customer_id", TO_CHAR(DATE_TRUNC('month', TO_DATE("txn_date", 'YYYY-MM-DD')), 'YYYY-MM')
),
customer_monthly_balances AS (
    SELECT 
        cm."customer_id",
        cm."month",
        COALESCE(mt."monthly_change", 0) AS "monthly_change"
    FROM customer_months cm
    LEFT JOIN monthly_transactions mt
    ON cm."customer_id" = mt."customer_id" AND cm."month" = mt."month"
),
customer_running_balance AS (
    SELECT 
        cmb."customer_id",
        cmb."month",
        ROUND(cmb."monthly_change", 4) AS "monthly_change",
        ROUND(SUM(cmb."monthly_change") OVER (
            PARTITION BY cmb."customer_id"
            ORDER BY cmb."month"
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 4) AS "ending_balance"
    FROM customer_monthly_balances cmb
)
SELECT 
    crb."customer_id",
    crb."month",
    crb."ending_balance",
    crb."monthly_change",
    crb."ending_balance" AS "cumulative_balance"
FROM customer_running_balance crb
ORDER BY crb."customer_id", crb."month";