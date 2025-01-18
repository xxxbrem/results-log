WITH delivered_orders AS (
  SELECT "order_id"
  FROM MODERN_DATA.MODERN_DATA.PIZZA_RUNNER_ORDERS
  WHERE ("cancellation" IS NULL OR "cancellation" = '') AND ("pickup_time" IS NOT NULL AND "pickup_time" <> '')
),
orders_with_toppings AS (
  SELECT
    co."order_id",
    co."pizza_id",
    co."exclusions",
    co."extras",
    REGEXP_REPLACE(pr."toppings", ' ', '') AS base_toppings
  FROM MODERN_DATA.MODERN_DATA.PIZZA_CUSTOMER_ORDERS co
  JOIN delivered_orders do ON co."order_id" = do."order_id"
  JOIN MODERN_DATA.MODERN_DATA.PIZZA_RECIPES pr ON co."pizza_id" = pr."pizza_id"
),
exploded_base_toppings AS (
  SELECT
    owt."order_id",
    t.value::NUMBER AS topping_id
  FROM orders_with_toppings owt,
  LATERAL FLATTEN(input => SPLIT(owt.base_toppings, ',')) t
),
exploded_exclusions AS (
  SELECT
    owt."order_id",
    t.value::NUMBER AS exclusion_topping_id
  FROM orders_with_toppings owt,
  LATERAL FLATTEN(input => SPLIT(REGEXP_REPLACE(owt."exclusions", ' ', ''), ',')) t
  WHERE owt."exclusions" IS NOT NULL AND owt."exclusions" <> ''
),
exploded_extras AS (
  SELECT
    owt."order_id",
    t.value::NUMBER AS extra_topping_id
  FROM orders_with_toppings owt,
  LATERAL FLATTEN(input => SPLIT(REGEXP_REPLACE(owt."extras", ' ', ''), ',')) t
  WHERE owt."extras" IS NOT NULL AND owt."extras" <> ''
),
toppings_after_exclusions AS (
  SELECT
    ebt."order_id",
    ebt.topping_id
  FROM exploded_base_toppings ebt
  LEFT JOIN exploded_exclusions ee
    ON ebt."order_id" = ee."order_id" AND ebt.topping_id = ee.exclusion_topping_id
  WHERE ee.exclusion_topping_id IS NULL
),
final_toppings AS (
  SELECT "order_id", topping_id FROM toppings_after_exclusions
  UNION ALL
  SELECT "order_id", extra_topping_id AS topping_id FROM exploded_extras
),
topping_counts AS (
  SELECT
    ft.topping_id,
    COUNT(*) AS Total_Quantity
  FROM final_toppings ft
  GROUP BY ft.topping_id
),
topping_names AS (
  SELECT
    tc.topping_id,
    tc.Total_Quantity,
    pt."topping_name" AS Topping_Name
  FROM topping_counts tc
  LEFT JOIN MODERN_DATA.MODERN_DATA.PIZZA_TOPPINGS pt
    ON tc.topping_id = pt."topping_id"
)
SELECT
  tn.Topping_Name,
  tn.Total_Quantity
FROM topping_names tn
ORDER BY tn.Total_Quantity DESC NULLS LAST;