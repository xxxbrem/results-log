WITH order_revenue AS
(
    SELECT co."order_id",
        CASE WHEN co."pizza_id" = 1 THEN 12 
             WHEN co."pizza_id" = 2 THEN 10 
        END AS base_price,
        CASE 
            WHEN co."extras" IS NULL OR co."extras" = '' THEN 0
            ELSE ARRAY_SIZE(SPLIT(co."extras", ',')) 
        END AS num_extras
    FROM MODERN_DATA.MODERN_DATA.PIZZA_CLEAN_CUSTOMER_ORDERS co
    JOIN MODERN_DATA.MODERN_DATA.PIZZA_CLEAN_RUNNER_ORDERS ro
        ON co."order_id" = ro."order_id"
    WHERE co."pizza_id" IN (1, 2)
      AND (ro."cancellation" IS NULL OR ro."cancellation" = '')
)
SELECT SUM(base_price + num_extras)::DECIMAL(10,4) AS "Total_income"
FROM order_revenue;