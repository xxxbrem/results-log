SELECT h."hub_id", h."hub_name",
       ROUND(((SUM(CASE WHEN o."order_created_month" = 3 THEN 1 ELSE 0 END) - SUM(CASE WHEN o."order_created_month" = 2 THEN 1 ELSE 0 END)) * 100.0
              / NULLIF(SUM(CASE WHEN o."order_created_month" = 2 THEN 1 ELSE 0 END), 0)), 4) AS "percentage_increase"
FROM DELIVERY_CENTER.DELIVERY_CENTER.ORDERS o
JOIN DELIVERY_CENTER.DELIVERY_CENTER.STORES s ON o."store_id" = s."store_id"
JOIN DELIVERY_CENTER.DELIVERY_CENTER.HUBS h ON s."hub_id" = h."hub_id"
WHERE o."order_status" = 'FINISHED'
  AND o."order_created_month" IN (2, 3)
GROUP BY h."hub_id", h."hub_name"
HAVING ((SUM(CASE WHEN o."order_created_month" = 3 THEN 1 ELSE 0 END) - SUM(CASE WHEN o."order_created_month" = 2 THEN 1 ELSE 0 END)) * 100.0
        / NULLIF(SUM(CASE WHEN o."order_created_month" = 2 THEN 1 ELSE 0 END), 0)) > 20.0;