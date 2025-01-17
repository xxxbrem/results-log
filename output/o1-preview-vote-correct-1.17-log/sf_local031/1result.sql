WITH annual_orders AS (
    SELECT SUBSTRING("order_purchase_timestamp",1,4) AS "year", COUNT(*) AS "total_delivered_orders"
    FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDERS"
    WHERE "order_status" = 'delivered' AND SUBSTRING("order_purchase_timestamp",1,4) IN ('2016','2017','2018')
    GROUP BY "year"
),
lowest_year AS (
    SELECT "year"
    FROM annual_orders
    ORDER BY "total_delivered_orders" ASC NULLS LAST
    LIMIT 1
),
monthly_orders AS (
    SELECT TO_NUMBER(SUBSTRING("order_purchase_timestamp",6,2)) AS "month", COUNT(*) AS "delivered_orders"
    FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDERS"
    WHERE "order_status" = 'delivered' AND SUBSTRING("order_purchase_timestamp",1,4) = (SELECT "year" FROM lowest_year)
    GROUP BY "month"
),
max_month AS (
    SELECT "month", "delivered_orders"
    FROM monthly_orders
    ORDER BY "delivered_orders" DESC NULLS LAST
    LIMIT 1
)
SELECT
    (SELECT "year" FROM lowest_year) AS "Year_with_lowest_annual_orders_volume",
    "month" AS "Month_with_highest_monthly_orders_volume",
    "delivered_orders" AS "Delivered_Orders_Volume"
FROM max_month;