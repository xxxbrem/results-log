WITH delivered_orders_per_year AS (
  SELECT
    EXTRACT(YEAR FROM TRY_TO_DATE("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) AS "year",
    COUNT("order_id") AS "delivered_orders"
  FROM "BRAZILIAN_E_COMMERCE"."BRAZILIAN_E_COMMERCE"."OLIST_ORDERS"
  WHERE "order_status" = 'delivered'
  GROUP BY "year"
  HAVING "year" IN (2016, 2017, 2018)
),
lowest_year AS (
  SELECT "year"
  FROM delivered_orders_per_year
  WHERE "delivered_orders" = (
    SELECT MIN("delivered_orders") FROM delivered_orders_per_year
  )
),
monthly_delivered_orders AS (
  SELECT
    EXTRACT(MONTH FROM TRY_TO_DATE("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) AS "month",
    COUNT("order_id") AS "delivered_orders"
  FROM "BRAZILIAN_E_COMMERCE"."BRAZILIAN_E_COMMERCE"."OLIST_ORDERS"
  WHERE "order_status" = 'delivered'
    AND EXTRACT(YEAR FROM TRY_TO_DATE("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) = (SELECT "year" FROM lowest_year)
  GROUP BY "month"
),
highest_monthly_orders_volume AS (
  SELECT MAX("delivered_orders") AS "highest_monthly_orders_volume"
  FROM monthly_delivered_orders
)
SELECT "highest_monthly_orders_volume"
FROM highest_monthly_orders_volume;