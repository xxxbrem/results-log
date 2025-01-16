WITH jan_cohort AS (
    SELECT "user_id"
    FROM (
        SELECT "user_id", MIN("created_at") AS "First_Order_Date"
        FROM THELOOK_ECOMMERCE.THELOOK_ECOMMERCE.ORDERS
        WHERE "status" IN ('Complete', 'Processing', 'Shipped')
        GROUP BY "user_id"
    ) first_orders
    WHERE TO_CHAR(TO_TIMESTAMP("First_Order_Date" / 1e6), 'YYYY-MM') = '2020-01'
),
cohort_size AS (
    SELECT COUNT(*) AS "cohort_size" FROM jan_cohort
),
user_orders AS (
    SELECT DISTINCT
        o."user_id",
        TO_CHAR(TO_TIMESTAMP(o."created_at" / 1e6), 'YYYY-MM') AS "Order_Month"
    FROM THELOOK_ECOMMERCE.THELOOK_ECOMMERCE.ORDERS o
    INNER JOIN jan_cohort jc ON o."user_id" = jc."user_id"
    WHERE TO_CHAR(TO_TIMESTAMP(o."created_at" / 1e6), 'YYYY') = '2020'
      AND TO_CHAR(TO_TIMESTAMP(o."created_at" / 1e6), 'YYYY-MM') > '2020-01'
      AND o."status" IN ('Complete', 'Processing', 'Shipped')
),
monthly_returns AS (
    SELECT
        "Order_Month",
        COUNT(DISTINCT "user_id") AS "Returning_Users"
    FROM user_orders
    GROUP BY "Order_Month"
),
months AS (
    SELECT '02' AS "Month_num", '2020-02' AS "Order_Month"
    UNION ALL SELECT '03', '2020-03'
    UNION ALL SELECT '04', '2020-04'
    UNION ALL SELECT '05', '2020-05'
    UNION ALL SELECT '06', '2020-06'
    UNION ALL SELECT '07', '2020-07'
    UNION ALL SELECT '08', '2020-08'
    UNION ALL SELECT '09', '2020-09'
    UNION ALL SELECT '10', '2020-10'
    UNION ALL SELECT '11', '2020-11'
    UNION ALL SELECT '12', '2020-12'
)
SELECT
    m."Month_num",
    TO_CHAR(TO_DATE(m."Order_Month" || '-01', 'YYYY-MM-DD'), 'Mon') AS "Month",
    COALESCE(ROUND(mr."Returning_Users"::FLOAT / (SELECT "cohort_size" FROM cohort_size)::FLOAT, 4), 0) AS "Proportion_returned"
FROM months m
LEFT JOIN monthly_returns mr ON m."Order_Month" = mr."Order_Month"
ORDER BY CAST(m."Month_num" AS INT);