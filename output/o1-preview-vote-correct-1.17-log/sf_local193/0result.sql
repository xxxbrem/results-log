WITH customer_payments AS (
    SELECT
        "customer_id",
        SUM("amount") AS "total_lifetime_sales",
        MIN("payment_date") AS "initial_purchase_date"
    FROM
        SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT
    GROUP BY
        "customer_id"
),
amounts_in_intervals AS (
    SELECT
        p."customer_id",
        p."amount",
        p."payment_date",
        cp."total_lifetime_sales",
        cp."initial_purchase_date",
        DATEDIFF('second', cp."initial_purchase_date", p."payment_date") AS "seconds_since_first_purchase"
    FROM
        SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT p
        INNER JOIN customer_payments cp ON p."customer_id" = cp."customer_id"
),
customer_summary AS (
    SELECT
        "customer_id",
        "total_lifetime_sales",
        SUM(CASE WHEN "seconds_since_first_purchase" <= 7*86400 THEN "amount" ELSE 0 END) AS "total_sales_first_7_days",
        SUM(CASE WHEN "seconds_since_first_purchase" <= 30*86400 THEN "amount" ELSE 0 END) AS "total_sales_first_30_days"
    FROM
        amounts_in_intervals
    GROUP BY
        "customer_id", "total_lifetime_sales"
)
SELECT
    ROUND(AVG("total_lifetime_sales"), 4) AS "average_total_LTV",
    ROUND(AVG(("total_sales_first_7_days" / "total_lifetime_sales") * 100), 4) AS "average_percentage_LTV_first_7_days",
    ROUND(AVG(("total_sales_first_30_days" / "total_lifetime_sales") * 100), 4) AS "average_percentage_LTV_first_30_days"
FROM
    customer_summary
WHERE
    "total_lifetime_sales" > 0;