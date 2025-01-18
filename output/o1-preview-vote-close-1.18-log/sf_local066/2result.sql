WITH delivered_orders AS (
  SELECT
    o."order_id",
    o."pizza_id",
    o."exclusions",
    o."extras",
    r."toppings" AS base_toppings
  FROM MODERN_DATA.MODERN_DATA.PIZZA_CLEAN_CUSTOMER_ORDERS o
  JOIN MODERN_DATA.MODERN_DATA.PIZZA_CLEAN_RUNNER_ORDERS ro ON o."order_id" = ro."order_id"
  JOIN MODERN_DATA.MODERN_DATA.PIZZA_RECIPES r ON o."pizza_id" = r."pizza_id"
  WHERE ro."cancellation" IS NULL OR ro."cancellation" = ''
),
parsed_orders AS (
  SELECT
    "order_id",
    "pizza_id",
    SPLIT(REGEXP_REPLACE(base_toppings, '\\s+', ''), ',') AS base_toppings_array,
    CASE WHEN "exclusions" IS NULL OR "exclusions" = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(REGEXP_REPLACE("exclusions", '\\s+', ''), ',') END AS exclusions_array,
    CASE WHEN "extras" IS NULL OR "extras" = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(REGEXP_REPLACE("extras", '\\s+', ''), ',') END AS extras_array
  FROM delivered_orders
),
final_toppings AS (
  SELECT
    "order_id",
    "pizza_id",
    ARRAY_CAT(ARRAY_EXCEPT(base_toppings_array, exclusions_array), extras_array) AS final_toppings_array
  FROM parsed_orders
)
SELECT
  t."topping_name" AS Ingredient,
  COUNT(*) AS Quantity
FROM final_toppings f,
LATERAL FLATTEN(input => f.final_toppings_array) ft
JOIN MODERN_DATA.MODERN_DATA.PIZZA_TOPPINGS t ON TO_NUMBER(ft.value) = t."topping_id"
GROUP BY t."topping_name"
ORDER BY t."topping_name";