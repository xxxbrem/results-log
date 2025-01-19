WITH trans AS (
    SELECT
        "customer_id",
        TO_CHAR(TRY_TO_DATE("txn_date", 'YYYY-MM-DD'), 'YYYY-MM') AS "month",
        SUM("txn_amount") AS "monthly_change"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CUSTOMER_TRANSACTIONS"
    GROUP BY
        "customer_id",
        TO_CHAR(TRY_TO_DATE("txn_date", 'YYYY-MM-DD'), 'YYYY-MM')
),
customers AS (
    SELECT DISTINCT "customer_id"
    FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CUSTOMER_TRANSACTIONS"
),
months AS (
    SELECT DISTINCT TO_CHAR(TRY_TO_DATE("txn_date", 'YYYY-MM-DD'), 'YYYY-MM') AS "month"
    FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CUSTOMER_TRANSACTIONS"
),
customer_months AS (
    SELECT c."customer_id", m."month"
    FROM customers c CROSS JOIN months m
),
monthly_changes AS (
    SELECT
        cm."customer_id",
        cm."month",
        COALESCE(t."monthly_change", 0) AS "monthly_change"
    FROM customer_months cm
    LEFT JOIN trans t
    ON cm."customer_id" = t."customer_id" AND cm."month" = t."month"
),
ordered_data AS (
    SELECT
        mc."customer_id",
        mc."month",
        mc."monthly_change",
        TO_DATE(mc."month" || '-01', 'YYYY-MM-DD') AS "month_date"
    FROM monthly_changes mc
),
cum_balances AS (
    SELECT
        "customer_id",
        "month",
        "monthly_change",
        SUM("monthly_change") OVER (
            PARTITION BY "customer_id"
            ORDER BY "month_date"
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS "closing_balance"
    FROM ordered_data
)
SELECT
    "customer_id",
    "month",
    "monthly_change",
    ROUND("closing_balance", 4) AS "closing_balance"
FROM cum_balances
ORDER BY
    "customer_id",
    "month";