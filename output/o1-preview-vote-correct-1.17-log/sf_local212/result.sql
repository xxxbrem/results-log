WITH delivery_data AS (
  SELECT D."driver_id",
         TO_DATE(
             O."order_created_year" || '-' ||
             LPAD(O."order_created_month", 2, '0') || '-' ||
             LPAD(O."order_created_day", 2, '0')
         ) AS delivery_date
  FROM DELIVERY_CENTER.DELIVERY_CENTER.DELIVERIES D
  JOIN DELIVERY_CENTER.DELIVERY_CENTER.ORDERS O ON D."delivery_order_id" = O."delivery_order_id"
  WHERE D."driver_id" IS NOT NULL
    AND O."order_created_year" IS NOT NULL
    AND O."order_created_month" IS NOT NULL
    AND O."order_created_day" IS NOT NULL
),
driver_stats AS (
  SELECT "driver_id",
         COUNT(*) AS total_deliveries,
         COUNT(DISTINCT delivery_date) AS days_worked,
         COUNT(*)::FLOAT / COUNT(DISTINCT delivery_date) AS average_daily_deliveries
  FROM delivery_data
  GROUP BY "driver_id"
),
driver_info AS (
  SELECT DS."driver_id",
         D."driver_modal",
         DS.average_daily_deliveries
  FROM driver_stats DS
  JOIN DELIVERY_CENTER.DELIVERY_CENTER.DRIVERS D ON DS."driver_id" = D."driver_id"
)
SELECT "driver_id", "driver_modal", ROUND(average_daily_deliveries, 4) AS "average_daily_deliveries"
FROM driver_info
ORDER BY average_daily_deliveries DESC NULLS LAST
LIMIT 5;