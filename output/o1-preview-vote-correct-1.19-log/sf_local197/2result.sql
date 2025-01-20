WITH TopCustomers AS (
    SELECT "customer_id", SUM("amount") AS "total_payment"
    FROM SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT
    GROUP BY "customer_id"
    ORDER BY "total_payment" DESC NULLS LAST
    LIMIT 10
),
MonthlyTotals AS (
    SELECT
        "customer_id",
        SUBSTR("payment_date", 1, 7) AS "payment_month",
        SUM("amount") AS "monthly_total"
    FROM SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT
    WHERE "customer_id" IN (SELECT "customer_id" FROM TopCustomers)
    GROUP BY "customer_id", SUBSTR("payment_date", 1, 7)
),
MonthlyDifferences AS (
    SELECT
        "customer_id",
        MAX("monthly_total") - MIN("monthly_total") AS "payment_difference"
    FROM MonthlyTotals
    GROUP BY "customer_id"
)
SELECT
    "customer_id" AS "Customer_ID",
    ROUND("payment_difference", 4) AS "Highest_Payment_Difference"
FROM MonthlyDifferences
ORDER BY "payment_difference" DESC NULLS LAST
LIMIT 1;