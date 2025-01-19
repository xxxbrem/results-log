WITH first_purchases AS (
    SELECT
        "user_id",
        MIN(TO_TIMESTAMP("created_at" / 1000000)) AS first_purchase_date
    FROM THELOOK_ECOMMERCE.THELOOK_ECOMMERCE.ORDERS
    GROUP BY "user_id"
),
january_cohort AS (
    SELECT "user_id"
    FROM first_purchases
    WHERE first_purchase_date >= DATE '2020-01-01' AND first_purchase_date < DATE '2020-02-01'
),
subsequent_purchases AS (
    SELECT DISTINCT
        "user_id",
        DATE_TRUNC('month', TO_TIMESTAMP("created_at" / 1000000)) AS purchase_month
    FROM THELOOK_ECOMMERCE.THELOOK_ECOMMERCE.ORDERS
    WHERE "user_id" IN (SELECT "user_id" FROM january_cohort)
          AND TO_TIMESTAMP("created_at" / 1000000) >= DATE '2020-02-01'
          AND TO_TIMESTAMP("created_at" / 1000000) < DATE '2021-01-01'
)
SELECT
    TO_CHAR(purchase_month, 'MM') AS "Month_num",
    TRIM(TO_CHAR(purchase_month, 'Month')) AS "Month",
    ROUND(COUNT(DISTINCT "user_id")::FLOAT / (SELECT COUNT(*) FROM january_cohort), 4) AS "Proportion_Returned"
FROM subsequent_purchases
GROUP BY purchase_month
ORDER BY purchase_month;