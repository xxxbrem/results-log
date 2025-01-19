SELECT SUM(total_income) AS Total_income
FROM (
  SELECT 
    (CASE 
      WHEN pn."pizza_name" = 'Meatlovers' THEN 12
      WHEN pn."pizza_name" = 'Vegetarian' THEN 10
      ELSE 0
    END) +
    (CASE
      WHEN pc."extras" IS NULL OR pc."extras" = '' THEN 0
      ELSE LENGTH(pc."extras") - LENGTH(REPLACE(pc."extras", ',', '')) + 1
    END) * 1 AS total_income
  FROM "pizza_customer_orders" pc
  JOIN "pizza_names" pn ON pc."pizza_id" = pn."pizza_id"
  WHERE pc."order_id" IN (
    SELECT "order_id"
    FROM "pizza_runner_orders"
    WHERE "cancellation" IS NULL OR "cancellation" = ''
  ) AND pn."pizza_name" IN ('Meatlovers', 'Vegetarian')
);