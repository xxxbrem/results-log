WITH first_purchase AS (
    SELECT
        "customer_id",
        MIN(TO_TIMESTAMP("payment_date", 'YYYY-MM-DD HH24:MI:SS.FF')) AS "first_purchase_date"
    FROM
        SQLITE_SAKILA.SQLITE_SAKILA."PAYMENT"
    GROUP BY
        "customer_id"
),
customer_payments AS (
    SELECT
        p."customer_id",
        p."amount",
        TO_TIMESTAMP(p."payment_date", 'YYYY-MM-DD HH24:MI:SS.FF') AS "payment_dt",
        fp."first_purchase_date"
    FROM
        SQLITE_SAKILA.SQLITE_SAKILA."PAYMENT" p
        JOIN first_purchase fp ON p."customer_id" = fp."customer_id"
),
customer_aggregates AS (
    SELECT
        "customer_id",
        SUM("amount") AS "total_lifetime_sales",
        SUM(
            CASE
                WHEN "payment_dt" >= "first_purchase_date"
                 AND "payment_dt" < DATEADD(day, 7, "first_purchase_date")
                THEN "amount"
                ELSE 0
            END
        ) AS "sales_in_first_7_days",
        SUM(
            CASE
                WHEN "payment_dt" >= "first_purchase_date"
                 AND "payment_dt" < DATEADD(day, 30, "first_purchase_date")
                THEN "amount"
                ELSE 0
            END
        ) AS "sales_in_first_30_days"
    FROM
        customer_payments
    GROUP BY
        "customer_id"
),
customer_percentages AS (
    SELECT
        "customer_id",
        "total_lifetime_sales",
        "sales_in_first_7_days",
        "sales_in_first_30_days",
        ("sales_in_first_7_days" / "total_lifetime_sales" * 100) AS "percentage_7_days",
        ("sales_in_first_30_days" / "total_lifetime_sales" * 100) AS "percentage_30_days"
    FROM
        customer_aggregates
    WHERE
        "total_lifetime_sales" > 0
)
SELECT
    ROUND(AVG("total_lifetime_sales"), 4) AS "Average_LTV",
    CONCAT(ROUND(AVG("percentage_7_days"), 4), '%') AS "Percentage_in_first_7_days",
    CONCAT(ROUND(AVG("percentage_30_days"), 4), '%') AS "Percentage_in_first_30_days"
FROM
    customer_percentages;