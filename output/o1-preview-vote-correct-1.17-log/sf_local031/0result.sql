WITH annual_orders AS (
  SELECT
    EXTRACT(YEAR FROM TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) AS "year",
    COUNT(*) AS "delivered_orders"
  FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDERS
  WHERE
    "order_status" = 'delivered'
    AND TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS') IS NOT NULL
    AND EXTRACT(YEAR FROM TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) IN (2016, 2017, 2018)
  GROUP BY "year"
),
min_year AS (
  SELECT "year"
  FROM annual_orders
  ORDER BY "delivered_orders" ASC NULLS LAST
  LIMIT 1
),
monthly_orders AS (
  SELECT
    EXTRACT(YEAR FROM TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) AS year,
    EXTRACT(MONTH FROM TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) AS month_num,
    MONTHNAME(TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) AS month_name,
    COUNT(*) AS delivered_orders_volume
  FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDERS
  WHERE
    "order_status" = 'delivered'
    AND TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS') IS NOT NULL
    AND EXTRACT(YEAR FROM TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) = (SELECT "year" FROM min_year)
  GROUP BY year, month_num, month_name
),
max_month AS (
  SELECT *
  FROM monthly_orders
  ORDER BY delivered_orders_volume DESC NULLS LAST
  LIMIT 1
)
SELECT
  year AS "Year",
  month_num AS "Month_num",
  month_name AS "Month",
  delivered_orders_volume AS "Delivered_Orders_Volume"
FROM max_month;