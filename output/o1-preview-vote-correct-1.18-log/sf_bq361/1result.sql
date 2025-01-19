WITH first_orders AS (
    SELECT "user_id", MIN(TO_TIMESTAMP("created_at" / 1000000)) AS first_order_date
    FROM THELOOK_ECOMMERCE.THELOOK_ECOMMERCE.ORDERS
    GROUP BY "user_id"
),
cohort_users AS (
    SELECT "user_id"
    FROM first_orders
    WHERE first_order_date >= '2020-01-01' AND first_order_date < '2020-02-01'
),
cohort_size AS (
    SELECT COUNT(DISTINCT "user_id") AS total_users
    FROM cohort_users
),
months AS (
    SELECT '2020-02-01'::DATE AS month_start UNION ALL
    SELECT '2020-03-01'::DATE UNION ALL
    SELECT '2020-04-01'::DATE UNION ALL
    SELECT '2020-05-01'::DATE UNION ALL
    SELECT '2020-06-01'::DATE UNION ALL
    SELECT '2020-07-01'::DATE UNION ALL
    SELECT '2020-08-01'::DATE UNION ALL
    SELECT '2020-09-01'::DATE UNION ALL
    SELECT '2020-10-01'::DATE UNION ALL
    SELECT '2020-11-01'::DATE UNION ALL
    SELECT '2020-12-01'::DATE
),
cohort_orders AS (
    SELECT DISTINCT "user_id", TO_TIMESTAMP("created_at" / 1000000)::DATE AS order_date
    FROM THELOOK_ECOMMERCE.THELOOK_ECOMMERCE.ORDERS
    WHERE "user_id" IN (SELECT "user_id" FROM cohort_users)
      AND TO_TIMESTAMP("created_at" / 1000000) >= '2020-02-01'
      AND TO_TIMESTAMP("created_at" / 1000000) < '2021-01-01'
)

SELECT
    TO_CHAR(months.month_start, 'Mon YYYY') AS "Month",
    ROUND(COALESCE(COUNT(DISTINCT cohort_orders."user_id")::FLOAT / (SELECT total_users FROM cohort_size), 0), 4) AS "Proportion"
FROM months
LEFT JOIN cohort_orders
ON cohort_orders.order_date >= months.month_start
   AND cohort_orders.order_date < DATEADD(month, 1, months.month_start)
GROUP BY months.month_start
ORDER BY months.month_start;