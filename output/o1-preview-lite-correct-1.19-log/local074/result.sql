WITH
months(month) AS (
    SELECT '2020-01' UNION ALL
    SELECT '2020-02' UNION ALL
    SELECT '2020-03' UNION ALL
        SELECT '2020-04'
),
customers(customer_id) AS (
    SELECT DISTINCT "customer_id"
    FROM "customer_transactions"
),
customer_months AS (
    SELECT customer_id, month
    FROM customers
    CROSS JOIN months
),
transactions_adjusted AS (
    SELECT
        "customer_id",
        STRFTIME('%Y-%m', "txn_date") AS "month",
        CASE
            WHEN "txn_type" = 'deposit' THEN "txn_amount"
            WHEN "txn_type" IN ('withdrawal', 'purchase') THEN - "txn_amount"
            ELSE 0
        END AS "txn_amount"
    FROM "customer_transactions"
),
monthly_changes AS (
    SELECT
        "customer_id",
        "month",
        SUM("txn_amount") AS "monthly_change"
    FROM transactions_adjusted
    GROUP BY "customer_id", "month"
),
customer_monthly_balances AS (
    SELECT
        cm.customer_id,
        cm.month,
        COALESCE(mc.monthly_change, 0) AS monthly_change
    FROM customer_months cm
    LEFT JOIN monthly_changes mc
        ON cm.customer_id = mc.customer_id
        AND cm.month = mc.month
),
cumulative_balances AS (
    SELECT
        customer_id,
        month,
        monthly_change,
        SUM(monthly_change) OVER (
            PARTITION BY customer_id
            ORDER BY month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_balance
    FROM customer_monthly_balances
)
SELECT
    customer_id,
    month,
    monthly_change,
    cumulative_balance
FROM cumulative_balances
ORDER BY customer_id, month;