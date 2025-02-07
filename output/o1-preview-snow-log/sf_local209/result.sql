SELECT
  "store_id",
  ROUND(SUM(CASE WHEN "order_status" = 'FINISHED' THEN 1 ELSE 0 END)::FLOAT / COUNT(*), 4) AS "completion_ratio"
FROM DELIVERY_CENTER.DELIVERY_CENTER.ORDERS
WHERE "store_id" = (
  SELECT "store_id"
  FROM DELIVERY_CENTER.DELIVERY_CENTER.ORDERS
  GROUP BY "store_id"
  ORDER BY COUNT(*) DESC NULLS LAST
  LIMIT 1
)
GROUP BY "store_id";