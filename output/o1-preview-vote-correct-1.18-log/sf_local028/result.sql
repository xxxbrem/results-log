WITH monthly_orders AS (
  SELECT
    EXTRACT(MONTH FROM TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) AS month_num,
    EXTRACT(YEAR FROM TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) AS year_num,
    COUNT(*) AS num_orders
  FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDERS"
  WHERE "order_status" = 'delivered'
    AND TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS') IS NOT NULL
    AND EXTRACT(YEAR FROM TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) IN (2016, 2017, 2018)
  GROUP BY month_num, year_num
)
SELECT
  TO_CHAR(DATE_FROM_PARTS(2000, month_num, 1), 'Mon') AS "Month",
  SUM(CASE WHEN year_num = 2016 THEN num_orders ELSE 0 END) AS "2016_delivered_orders",
  SUM(CASE WHEN year_num = 2017 THEN num_orders ELSE 0 END) AS "2017_delivered_orders",
  SUM(CASE WHEN year_num = 2018 THEN num_orders ELSE 0 END) AS "2018_delivered_orders"
FROM monthly_orders
GROUP BY month_num
ORDER BY month_num;