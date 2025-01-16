WITH user_first_purchase AS (
    SELECT "user_id",
           MIN("created_at") AS "first_purchase_us"
    FROM "THELOOK_ECOMMERCE"."THELOOK_ECOMMERCE"."ORDERS"
    GROUP BY "user_id"
),
user_first_purchase_date AS (
    SELECT "user_id",
           TO_TIMESTAMP_NTZ("first_purchase_us" / 1e6) AS "first_purchase_date"
    FROM user_first_purchase
),
january_2020_cohort AS (
    SELECT "user_id"
    FROM user_first_purchase_date
    WHERE "first_purchase_date" >= '2020-01-01'::DATE
      AND "first_purchase_date" < '2020-02-01'::DATE
),
cohort_orders AS (
    SELECT o."user_id",
           TO_TIMESTAMP_NTZ(o."created_at" / 1e6) AS "order_date"
    FROM "THELOOK_ECOMMERCE"."THELOOK_ECOMMERCE"."ORDERS" o
    INNER JOIN january_2020_cohort c ON o."user_id" = c."user_id"
    WHERE TO_TIMESTAMP_NTZ(o."created_at" / 1e6) >= '2020-02-01'::DATE
      AND TO_TIMESTAMP_NTZ(o."created_at" / 1e6) < '2021-01-01'::DATE
),
monthly_returns AS (
    SELECT DATE_TRUNC('MONTH', "order_date") AS "month",
           COUNT(DISTINCT "user_id") AS "Number_of_users_returned"
    FROM cohort_orders
    GROUP BY DATE_TRUNC('MONTH', "order_date")
),
cohort_size AS (
    SELECT COUNT(DISTINCT "user_id") AS "Total_users_in_cohort"
    FROM january_2020_cohort
)
SELECT 
    TO_CHAR("month", 'MM') AS "Month_num",
    TO_CHAR("month", 'Month') AS "Month",
    mr."Number_of_users_returned",
    cs."Total_users_in_cohort",
    ROUND(mr."Number_of_users_returned"::FLOAT / cs."Total_users_in_cohort", 4) AS "Proportion_returned"
FROM monthly_returns mr, cohort_size cs
ORDER BY "Month_num";