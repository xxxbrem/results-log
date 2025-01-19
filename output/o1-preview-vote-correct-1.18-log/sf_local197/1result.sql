WITH top_customers AS (
    SELECT "customer_id", SUM("amount") AS "total_amount"
    FROM SQLITE_SAKILA.SQLITE_SAKILA."PAYMENT"
    GROUP BY "customer_id"
    ORDER BY "total_amount" DESC NULLS LAST
    LIMIT 10
),
payment_data AS (
    SELECT
        p."customer_id",
        TO_TIMESTAMP(p."payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3') AS "payment_date",
        p."amount"
    FROM
        SQLITE_SAKILA.SQLITE_SAKILA."PAYMENT" p
    WHERE
        p."customer_id" IN (SELECT "customer_id" FROM top_customers)
),
customer_monthly_differences AS (
    SELECT
        pd."customer_id",
        TO_CHAR(pd."payment_date", 'YYYY-MM') AS "month",
        MAX(pd."amount") AS "max_amount",
        MIN(pd."amount") AS "min_amount",
        ROUND(MAX(pd."amount") - MIN(pd."amount"), 4) AS "difference"
    FROM
        payment_data pd
    GROUP BY
        pd."customer_id",
        TO_CHAR(pd."payment_date", 'YYYY-MM')
),
customer_max_difference AS (
    SELECT
        "customer_id",
        MAX("difference") AS "highest_payment_difference"
    FROM
        customer_monthly_differences
    GROUP BY
        "customer_id"
)
SELECT
    "customer_id",
    ROUND("highest_payment_difference", 4) AS "Highest_Payment_Difference"
FROM
    customer_max_difference
ORDER BY
    "highest_payment_difference" DESC NULLS LAST
LIMIT 1;