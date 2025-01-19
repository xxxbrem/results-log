WITH hub_orders AS (
  SELECT "hubs"."hub_id", "hubs"."hub_name",
         SUM(CASE WHEN "orders"."order_status" = 'FINISHED' AND "orders"."order_created_month" = 2 THEN 1 ELSE 0 END) AS "Feb_orders",
         SUM(CASE WHEN "orders"."order_status" = 'FINISHED' AND "orders"."order_created_month" = 3 THEN 1 ELSE 0 END) AS "Mar_orders"
  FROM "orders"
  JOIN "stores" ON "orders"."store_id" = "stores"."store_id"
  JOIN "hubs" ON "stores"."hub_id" = "hubs"."hub_id"
  GROUP BY "hubs"."hub_id", "hubs"."hub_name"
)
SELECT "hub_id", "hub_name"
FROM hub_orders
WHERE "Feb_orders" > 0 AND ROUND(((("Mar_orders" - "Feb_orders") * 100.0) / "Feb_orders"), 4) > 20;