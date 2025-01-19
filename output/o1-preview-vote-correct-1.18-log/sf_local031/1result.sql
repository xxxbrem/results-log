WITH
annual_volumes AS (
   SELECT SUBSTRING("order_delivered_customer_date", 1, 4) AS "Year", COUNT("order_id") AS "Delivered_Orders"
   FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDERS
   WHERE "order_status" = 'delivered'
     AND "order_delivered_customer_date" IS NOT NULL
     AND "order_delivered_customer_date" <> ''
     AND SUBSTRING("order_delivered_customer_date", 1, 4) IN ('2016','2017','2018')
   GROUP BY "Year"
),
lowest_year AS (
   SELECT "Year"
   FROM annual_volumes
   ORDER BY "Delivered_Orders" ASC NULLS LAST
   LIMIT 1
),
monthly_volumes AS (
   SELECT SUBSTRING("order_delivered_customer_date", 6, 2) AS "Month",
          COUNT("order_id") AS "Delivered_Orders"
   FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDERS
   WHERE "order_status" = 'delivered'
     AND "order_delivered_customer_date" IS NOT NULL
     AND "order_delivered_customer_date" <> ''
     AND SUBSTRING("order_delivered_customer_date", 1, 4) = (SELECT "Year" FROM lowest_year)
     AND SUBSTRING("order_delivered_customer_date", 6, 2) <> ''
   GROUP BY "Month"
)
SELECT "Delivered_Orders" AS Highest_monthly_delivered_orders_volume,
       TO_NUMBER("Month") AS Month
FROM monthly_volumes
ORDER BY "Delivered_Orders" DESC NULLS LAST
LIMIT 1;