SELECT h."hub_id",
       h."hub_name"
FROM DELIVERY_CENTER.DELIVERY_CENTER.HUBS h
JOIN (
    SELECT s."hub_id", COUNT(*) AS "finished_orders_feb"
    FROM DELIVERY_CENTER.DELIVERY_CENTER.ORDERS o
    JOIN DELIVERY_CENTER.DELIVERY_CENTER.STORES s ON o."store_id" = s."store_id"
    WHERE o."order_status" = 'FINISHED'
      AND o."order_created_year" = 2021
      AND o."order_created_month" = 2
    GROUP BY s."hub_id"
) feb_orders ON h."hub_id" = feb_orders."hub_id"
JOIN (
    SELECT s."hub_id", COUNT(*) AS "finished_orders_mar"
    FROM DELIVERY_CENTER.DELIVERY_CENTER.ORDERS o
    JOIN DELIVERY_CENTER.DELIVERY_CENTER.STORES s ON o."store_id" = s."store_id"
    WHERE o."order_status" = 'FINISHED'
      AND o."order_created_year" = 2021
      AND o."order_created_month" = 3
    GROUP BY s."hub_id"
) mar_orders ON h."hub_id" = mar_orders."hub_id"
WHERE ((mar_orders."finished_orders_mar" - feb_orders."finished_orders_feb")::FLOAT / feb_orders."finished_orders_feb") * 100 > 20
ORDER BY h."hub_id";