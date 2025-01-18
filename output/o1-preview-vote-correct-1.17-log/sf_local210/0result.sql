WITH finished_orders AS (
  SELECT
    O."order_id",
    S."hub_id",
    O."order_created_month",
    O."order_created_year"
  FROM
    DELIVERY_CENTER.DELIVERY_CENTER."ORDERS" O
    INNER JOIN DELIVERY_CENTER.DELIVERY_CENTER."STORES" S
      ON O."store_id" = S."store_id"
  WHERE
    O."order_status" = 'FINISHED'
    AND O."order_created_year" = 2021
    AND O."order_created_month" IN (2, 3)
),
orders_per_hub AS (
  SELECT
    F."hub_id",
    F."order_created_month",
    COUNT(DISTINCT F."order_id") AS "num_orders"
  FROM
    finished_orders F
  GROUP BY
    F."hub_id",
    F."order_created_month"
),
orders_pivot AS (
  SELECT
    O."hub_id",
    COALESCE(FEB."num_orders", 0) AS "feb_orders",
    COALESCE(MAR."num_orders", 0) AS "mar_orders"
  FROM
    (SELECT DISTINCT "hub_id" FROM orders_per_hub) O
    LEFT JOIN orders_per_hub FEB
      ON O."hub_id" = FEB."hub_id" AND FEB."order_created_month" = 2
    LEFT JOIN orders_per_hub MAR
      ON O."hub_id" = MAR."hub_id" AND MAR."order_created_month" = 3
)
SELECT
  P."hub_id",
  H."hub_name",
  ROUND(((P."mar_orders" - P."feb_orders") / P."feb_orders") * 100, 4) AS "percentage_increase"
FROM
  orders_pivot P
  INNER JOIN DELIVERY_CENTER.DELIVERY_CENTER."HUBS" H
    ON P."hub_id" = H."hub_id"
WHERE
  P."feb_orders" > 0
  AND ((P."mar_orders" - P."feb_orders") / P."feb_orders") * 100 > 20
ORDER BY
  "percentage_increase" DESC NULLS LAST;