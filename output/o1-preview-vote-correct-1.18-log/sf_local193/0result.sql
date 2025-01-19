WITH customer_payments AS (
    SELECT
        "customer_id",
        SUM("amount") AS total_ltv,
        MIN(TO_TIMESTAMP_NTZ("payment_date")) AS first_payment_date
    FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
    GROUP BY "customer_id"
),
payments_with_first_date AS (
    SELECT
        p."customer_id",
        TO_TIMESTAMP_NTZ(p."payment_date") AS payment_date,
        p."amount",
        c.total_ltv,
        c.first_payment_date
    FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT" p
    JOIN customer_payments c
        ON p."customer_id" = c."customer_id"
),
payments_in_first_7_30_days AS (
    SELECT
        "customer_id",
        total_ltv,
        SUM(CASE WHEN payment_date <= DATEADD('SECOND', 604800, first_payment_date) THEN "amount" ELSE 0 END) AS amount_first_7_days,
        SUM(CASE WHEN payment_date <= DATEADD('SECOND', 2592000, first_payment_date) THEN "amount" ELSE 0 END) AS amount_first_30_days
    FROM payments_with_first_date
    GROUP BY "customer_id", total_ltv
),
customers_with_nonzero_ltv AS (
    SELECT *
    FROM payments_in_first_7_30_days
    WHERE total_ltv > 0
)
SELECT
    ROUND(AVG(total_ltv), 4) AS "Average_Total_LTV",
    CONCAT(ROUND(AVG((amount_first_7_days / total_ltv) * 100), 4), '%') AS "Percentage_of_LTV_in_First_7_Days",
    CONCAT(ROUND(AVG((amount_first_30_days / total_ltv) * 100), 4), '%') AS "Percentage_of_LTV_in_First_30_Days"
FROM customers_with_nonzero_ltv;