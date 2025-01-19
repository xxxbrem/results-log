WITH date_range AS (
    SELECT
        DATE_TRUNC('month', MIN(TO_DATE("txn_date"))) AS "start_date",
        DATE_TRUNC('month', MAX(TO_DATE("txn_date"))) AS "end_date"
    FROM BANK_SALES_TRADING.BANK_SALES_TRADING.CUSTOMER_TRANSACTIONS
),
months AS (
    SELECT "start_date" AS "month_start"
    FROM date_range
    UNION ALL
    SELECT DATEADD('month', 1, "month_start") AS "month_start"
    FROM months
    WHERE "month_start" < (SELECT "end_date" FROM date_range)
),
customers AS (
    SELECT DISTINCT "customer_id"
    FROM BANK_SALES_TRADING.BANK_SALES_TRADING.CUSTOMER_TRANSACTIONS
),
customer_months AS (
    SELECT c."customer_id", m."month_start"
    FROM customers c
    CROSS JOIN months m
),
transactions_with_sign AS (
    SELECT
        "customer_id",
        TO_DATE("txn_date") AS "txn_date",
        DATE_TRUNC('month', TO_DATE("txn_date")) AS "month_start",
        CASE
            WHEN LOWER("txn_type") = 'deposit' THEN "txn_amount"
            WHEN LOWER("txn_type") IN ('withdrawal', 'purchase') THEN - "txn_amount"
            ELSE 0
        END AS "signed_amount"
    FROM BANK_SALES_TRADING.BANK_SALES_TRADING.CUSTOMER_TRANSACTIONS
),
monthly_transactions AS (
    SELECT
        "customer_id",
        "month_start",
        SUM("signed_amount") AS "monthly_amount"
    FROM transactions_with_sign
    GROUP BY "customer_id", "month_start"
),
customer_cumulative AS (
    SELECT
        cm."customer_id",
        cm."month_start",
        COALESCE(mt."monthly_amount", 0) AS "monthly_amount"
    FROM customer_months cm
    LEFT JOIN monthly_transactions mt
        ON cm."customer_id" = mt."customer_id" AND cm."month_start" = mt."month_start"
),
customer_balances AS (
    SELECT
        "customer_id",
        "month_start",
        SUM("monthly_amount") OVER (
            PARTITION BY "customer_id"
            ORDER BY "month_start"
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS "closing_balance"
    FROM customer_cumulative
),
customer_balances_with_change AS (
    SELECT
        "customer_id",
        "month_start",
        "closing_balance",
        ROUND("closing_balance" - LAG("closing_balance", 1, 0) OVER (
            PARTITION BY "customer_id"
            ORDER BY "month_start"
        ), 4) AS "monthly_change",
        ROUND("closing_balance", 4) AS "cumulative_balance"
    FROM customer_balances
)
SELECT
    "customer_id",
    TO_CHAR("month_start", 'YYYY-MM') AS "year_month",
    ROUND("closing_balance", 4) AS "closing_balance",
    "monthly_change",
    "cumulative_balance"
FROM customer_balances_with_change
ORDER BY "customer_id", "month_start";