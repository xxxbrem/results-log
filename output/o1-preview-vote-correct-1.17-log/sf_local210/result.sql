SELECT
  h."hub_id",
  h."hub_name"
FROM
  "DELIVERY_CENTER"."DELIVERY_CENTER"."HUBS" h
  JOIN "DELIVERY_CENTER"."DELIVERY_CENTER"."STORES" s ON h."hub_id" = s."hub_id"
  JOIN "DELIVERY_CENTER"."DELIVERY_CENTER"."ORDERS" o ON s."store_id" = o."store_id"
WHERE
  o."order_status" = 'FINISHED'
  AND o."order_created_year" = 2021
  AND o."order_created_month" IN (2, 3)
GROUP BY
  h."hub_id",
  h."hub_name"
HAVING
  SUM(CASE WHEN o."order_created_month" = 2 THEN 1 ELSE 0 END) > 0
  AND (
    (SUM(CASE WHEN o."order_created_month" = 3 THEN 1 ELSE 0 END)
     - SUM(CASE WHEN o."order_created_month" = 2 THEN 1 ELSE 0 END)) * 100.0
    / SUM(CASE WHEN o."order_created_month" = 2 THEN 1 ELSE 0 END)
  ) > 20
ORDER BY
  (
    (SUM(CASE WHEN o."order_created_month" = 3 THEN 1 ELSE 0 END)
     - SUM(CASE WHEN o."order_created_month" = 2 THEN 1 ELSE 0 END)) * 100.0
    / NULLIF(SUM(CASE WHEN o."order_created_month" = 2 THEN 1 ELSE 0 END), 0)
  ) DESC NULLS LAST;