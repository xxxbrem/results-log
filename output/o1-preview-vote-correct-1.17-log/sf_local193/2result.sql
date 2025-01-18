SELECT
    ROUND(AVG(cs."total_lifetime_sales"), 4) AS "average_total_lifetime_sales",
    CONCAT(ROUND(AVG((cs."sales_first_7_days" / cs."total_lifetime_sales") * 100), 4), '%') AS "percentage_sales_first_7_days",
    CONCAT(ROUND(AVG((cs."sales_first_30_days" / cs."total_lifetime_sales") * 100), 4), '%') AS "percentage_sales_first_30_days"
FROM (
    SELECT
        p."customer_id",
        SUM(p."amount") AS "total_lifetime_sales",
        SUM(
            CASE
                WHEN TO_TIMESTAMP_NTZ(p."payment_date") <= DATEADD(second, 604800, init_p."initial_purchase_date")
                THEN p."amount"
                ELSE 0
            END
        ) AS "sales_first_7_days",
        SUM(
            CASE
                WHEN TO_TIMESTAMP_NTZ(p."payment_date") <= DATEADD(second, 2592000, init_p."initial_purchase_date")
                THEN p."amount"
                ELSE 0
            END
        ) AS "sales_first_30_days"
    FROM
        "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT" p
    INNER JOIN (
        SELECT
            "customer_id",
            MIN(TO_TIMESTAMP_NTZ("payment_date")) AS "initial_purchase_date"
        FROM
            "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
        GROUP BY
            "customer_id"
    ) init_p ON p."customer_id" = init_p."customer_id"
    GROUP BY
        p."customer_id"
    HAVING
        SUM(p."amount") > 0
) cs;