SELECT
  TO_CHAR(TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS'), 'MM') AS "Month_num",
  TO_CHAR(TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS'), 'Mon') AS "Month",
  SUM(CASE WHEN EXTRACT(YEAR FROM TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) = 2016 THEN 1 ELSE 0 END) AS "2016",
  SUM(CASE WHEN EXTRACT(YEAR FROM TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) = 2017 THEN 1 ELSE 0 END) AS "2017",
  SUM(CASE WHEN EXTRACT(YEAR FROM TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) = 2018 THEN 1 ELSE 0 END) AS "2018"
FROM
  BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDERS
WHERE
  "order_status" = 'delivered'
  AND "order_delivered_customer_date" IS NOT NULL
  AND TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS') IS NOT NULL
GROUP BY
  1, 2
ORDER BY
  1;