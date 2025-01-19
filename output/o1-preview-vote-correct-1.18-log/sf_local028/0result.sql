WITH parsed_orders AS (
  SELECT
    TRY_TO_TIMESTAMP("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS') AS "delivery_timestamp",
    "order_id"
  FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDERS"
  WHERE
    "order_status" = 'delivered' AND
    "order_delivered_customer_date" IS NOT NULL AND
    "order_delivered_customer_date" <> ''
)
SELECT
  TO_CHAR("delivery_timestamp", 'FMMonth') AS "Month",
  SUM(CASE WHEN EXTRACT(YEAR FROM "delivery_timestamp") = 2016 THEN 1 ELSE 0 END) AS "2016",
  SUM(CASE WHEN EXTRACT(YEAR FROM "delivery_timestamp") = 2017 THEN 1 ELSE 0 END) AS "2017",
  SUM(CASE WHEN EXTRACT(YEAR FROM "delivery_timestamp") = 2018 THEN 1 ELSE 0 END) AS "2018"
FROM parsed_orders
GROUP BY
  EXTRACT(MONTH FROM "delivery_timestamp"),
  TO_CHAR("delivery_timestamp", 'FMMonth')
ORDER BY
  EXTRACT(MONTH FROM "delivery_timestamp");