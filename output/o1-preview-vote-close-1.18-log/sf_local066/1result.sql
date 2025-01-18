WITH delivered_orders AS (
    SELECT DISTINCT "order_id"
    FROM "MODERN_DATA"."MODERN_DATA"."PIZZA_RUNNER_ORDERS"
    WHERE "cancellation" IS NULL OR TRIM("cancellation") = ''
),
customer_orders AS (
    SELECT co.*
    FROM "MODERN_DATA"."MODERN_DATA"."PIZZA_CUSTOMER_ORDERS" co
    INNER JOIN delivered_orders do ON co."order_id" = do."order_id"
),
recipes AS (
    SELECT "pizza_id", "toppings"
    FROM "MODERN_DATA"."MODERN_DATA"."PIZZA_RECIPES"
),
toppings AS (
    SELECT "topping_id", "topping_name"
    FROM "MODERN_DATA"."MODERN_DATA"."PIZZA_TOPPINGS"
),
order_toppings AS (
    SELECT
        co."order_id",
        co."pizza_id",
        SPLIT(TRIM(r."toppings"), ',') AS "default_toppings",
        SPLIT(NULLIF(TRIM(co."exclusions"), ''), ',') AS "exclusion_toppings",
        SPLIT(NULLIF(TRIM(co."extras"), ''), ',') AS "extra_toppings"
    FROM customer_orders co
    INNER JOIN recipes r ON co."pizza_id" = r."pizza_id"
),
adjusted_toppings AS (
    SELECT
        "order_id",
        "pizza_id",
        ARRAY_DISTINCT(
            ARRAY_CAT(
                ARRAY_EXCEPT("default_toppings", COALESCE("exclusion_toppings", ARRAY_CONSTRUCT())),
                COALESCE("extra_toppings", ARRAY_CONSTRUCT())
            )
        ) AS "actual_toppings"
    FROM order_toppings
),
topping_counts AS (
    SELECT
        t.value::NUMBER AS "topping_id"
    FROM adjusted_toppings at,
    LATERAL FLATTEN(input => at."actual_toppings") t
),
ingredient_totals AS (
    SELECT
        tc."topping_id",
        COUNT(*) AS "Quantity"
    FROM topping_counts tc
    GROUP BY tc."topping_id"
),
ingredient_names AS (
    SELECT
        t."topping_name" AS "Ingredient",
        it."Quantity"
    FROM ingredient_totals it
    INNER JOIN toppings t ON it."topping_id" = t."topping_id"
)
SELECT
    "Ingredient",
    "Quantity"
FROM ingredient_names
ORDER BY "Ingredient";