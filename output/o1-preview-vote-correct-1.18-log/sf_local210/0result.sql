WITH finished_orders AS (
    SELECT s."hub_id",
           o."order_created_month",
           COUNT(*) AS "finished_orders"
    FROM DELIVERY_CENTER.DELIVERY_CENTER.ORDERS o
    JOIN DELIVERY_CENTER.DELIVERY_CENTER.STORES s ON o."store_id" = s."store_id"
    WHERE o."order_status" = 'FINISHED'
      AND o."order_created_year" = 2021
      AND o."order_created_month" IN (2, 3)
    GROUP BY s."hub_id", o."order_created_month"
),
orders_by_hub AS (
    SELECT
        "hub_id",
        SUM(CASE WHEN "order_created_month" = 2 THEN "finished_orders" ELSE 0 END) AS "feb_orders",
        SUM(CASE WHEN "order_created_month" = 3 THEN "finished_orders" ELSE 0 END) AS "mar_orders"
    FROM finished_orders
    GROUP BY "hub_id"
),
percentage_increase AS (
    SELECT
        obh."hub_id",
        h."hub_name",
        obh."feb_orders",
        obh."mar_orders",
        CASE
            WHEN obh."feb_orders" = 0 THEN NULL
            ELSE ROUND(((obh."mar_orders" - obh."feb_orders") / obh."feb_orders") * 100.0, 4)
        END AS "percent_increase"
    FROM orders_by_hub obh
    JOIN DELIVERY_CENTER.DELIVERY_CENTER.HUBS h ON obh."hub_id" = h."hub_id"
)
SELECT
    "hub_id",
    "hub_name"
FROM percentage_increase
WHERE "percent_increase" > 20
ORDER BY "hub_id";