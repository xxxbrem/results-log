WITH months AS (
    SELECT 
        DATEADD(month, seq4(), '2020-01-01') AS "month_date"
    FROM TABLE(GENERATOR(ROWCOUNT => 4))
),
customers AS (
    SELECT DISTINCT "customer_id"
    FROM BANK_SALES_TRADING.BANK_SALES_TRADING.CUSTOMER_TRANSACTIONS
),
customer_months AS (
    SELECT 
        c."customer_id",
        m."month_date"
    FROM customers c
    CROSS JOIN months m
),
transactions AS (
    SELECT 
        "customer_id",
        DATE_TRUNC('month', TO_DATE("txn_date", 'YYYY-MM-DD')) AS "month_date",
        CASE 
            WHEN "txn_type" = 'deposit' THEN "txn_amount"
            ELSE -"txn_amount"
        END AS "adjusted_amount"
    FROM BANK_SALES_TRADING.BANK_SALES_TRADING.CUSTOMER_TRANSACTIONS
    WHERE TRY_TO_DATE("txn_date", 'YYYY-MM-DD') IS NOT NULL
),
monthly_changes AS (
    SELECT 
        "customer_id",
        "month_date",
        SUM("adjusted_amount") AS "monthly_change"
    FROM transactions
    GROUP BY "customer_id", "month_date"
),
customer_balances AS (
    SELECT 
        cm."customer_id",
        cm."month_date",
        COALESCE(mc."monthly_change", 0) AS "monthly_change"
    FROM customer_months cm
    LEFT JOIN monthly_changes mc 
        ON cm."customer_id" = mc."customer_id" AND cm."month_date" = mc."month_date"
),
final_balances AS (
    SELECT 
        "customer_id",
        EXTRACT(MONTH FROM "month_date") AS "month_num",
        TO_CHAR("month_date", 'Month') AS "month",
        ROUND("monthly_change", 4) AS "monthly_change",
        ROUND(SUM("monthly_change") OVER (
            PARTITION BY "customer_id" 
            ORDER BY "month_date" 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 4) AS "closing_balance"
    FROM customer_balances
)

SELECT
    "customer_id",
    LPAD("month_num"::VARCHAR, 2, '0') AS "month_num",
    RTRIM("month") AS "month",
    "monthly_change",
    "closing_balance"
FROM final_balances
ORDER BY "customer_id", "month_num";