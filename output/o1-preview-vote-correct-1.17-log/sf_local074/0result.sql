WITH date_range AS (
    SELECT MIN(TO_DATE("txn_date", 'YYYY-MM-DD')) AS min_date,
           MAX(TO_DATE("txn_date", 'YYYY-MM-DD')) AS max_date
    FROM BANK_SALES_TRADING.BANK_SALES_TRADING.CUSTOMER_TRANSACTIONS
),
months AS (
    SELECT min_date AS month_start_date,
           TO_CHAR(min_date, 'YYYY-MM') AS "month_year"
    FROM date_range
    UNION ALL
    SELECT DATEADD(month, 1, month_start_date) AS month_start_date,
           TO_CHAR(DATEADD(month, 1, month_start_date), 'YYYY-MM') AS "month_year"
    FROM months
    WHERE DATEADD(month, 1, month_start_date) <= (SELECT max_date FROM date_range)
),
customers AS (
    SELECT DISTINCT "customer_id"
    FROM BANK_SALES_TRADING.BANK_SALES_TRADING.CUSTOMER_TRANSACTIONS
),
cust_months AS (
    SELECT c."customer_id", m."month_year", m.month_start_date
    FROM customers c
    CROSS JOIN months m
),
monthly_transactions AS (
    SELECT "customer_id",
           TO_CHAR(TO_DATE("txn_date", 'YYYY-MM-DD'), 'YYYY-MM') AS "month_year",
           SUM("txn_amount") AS monthly_change
    FROM BANK_SALES_TRADING.BANK_SALES_TRADING.CUSTOMER_TRANSACTIONS
    GROUP BY "customer_id", TO_CHAR(TO_DATE("txn_date", 'YYYY-MM-DD'), 'YYYY-MM')
),
cust_months_with_trans AS (
    SELECT cm."customer_id",
           cm."month_year",
           cm.month_start_date,
           COALESCE(mt.monthly_change, 0.00) AS monthly_change
    FROM cust_months cm
    LEFT JOIN monthly_transactions mt
        ON cm."customer_id" = mt."customer_id" AND cm."month_year" = mt."month_year"
),
balances AS (
    SELECT
        cmwt."customer_id",
        cmwt."month_year",
        cmwt.month_start_date,
        COALESCE(SUM(cmwt.monthly_change) OVER (
            PARTITION BY cmwt."customer_id"
            ORDER BY cmwt.month_start_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ), 0.00) AS opening_balance,
        cmwt.monthly_change,
        COALESCE(SUM(cmwt.monthly_change) OVER (
            PARTITION BY cmwt."customer_id"
            ORDER BY cmwt.month_start_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 0.00) AS closing_balance
    FROM cust_months_with_trans cmwt
)
SELECT
    b."customer_id",
    b."month_year",
    ROUND(b.opening_balance, 4) AS opening_balance,
    ROUND(b.monthly_change, 4) AS monthly_change,
    ROUND(b.closing_balance, 4) AS closing_balance
FROM balances b
ORDER BY b."customer_id", b.month_start_date;