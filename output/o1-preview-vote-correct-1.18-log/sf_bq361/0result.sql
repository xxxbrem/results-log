WITH user_first_purchase AS (
    SELECT "user_id", MIN("created_at") AS "first_purchase_date"
    FROM THELOOK_ECOMMERCE.THELOOK_ECOMMERCE.ORDERS
    GROUP BY "user_id"
),
jan2020_cohort AS (
    SELECT "user_id" FROM user_first_purchase
    WHERE "first_purchase_date" BETWEEN 1577836800000000 AND 1580515199000000
),
orders_2020 AS (
    SELECT "user_id",
           DATE_TRUNC('month', TO_TIMESTAMP("created_at" / 1000000)) AS "month"
    FROM THELOOK_ECOMMERCE.THELOOK_ECOMMERCE.ORDERS
    WHERE "created_at" BETWEEN 1577836800000000 AND 1609459199000000
), 
cohort_orders AS (
    SELECT DISTINCT jan2020_cohort."user_id", orders_2020."month"
    FROM jan2020_cohort
    JOIN orders_2020 ON jan2020_cohort."user_id" = orders_2020."user_id"
    WHERE orders_2020."month" >= DATE_TRUNC('month', '2020-02-01'::date)
),
month_list AS (
    SELECT DATE_TRUNC('month', DATEADD(month, ROW_NUMBER() OVER (ORDER BY NULL) - 1, '2020-02-01')) AS "month"
    FROM TABLE(GENERATOR(ROWCOUNT => 11))
)
SELECT TO_CHAR(month_list."month", 'Mon') AS "Month",
       ROUND(COUNT(DISTINCT cohort_orders."user_id")::decimal / (SELECT COUNT(*) FROM jan2020_cohort), 4) AS "Proportion"
FROM month_list
LEFT JOIN cohort_orders ON cohort_orders."month" = month_list."month"
GROUP BY month_list."month"
ORDER BY month_list."month";