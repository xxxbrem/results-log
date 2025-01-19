SELECT ROUND(SUM(
        CASE WHEN p."pizza_name" = 'Meatlovers' THEN 12
             WHEN p."pizza_name" = 'Vegetarian' THEN 10
        END
        +
        CASE WHEN TRIM(c."extras") != '' THEN ARRAY_SIZE(SPLIT(c."extras", ',')) * 1 ELSE 0 END
    ), 4) AS total_income
FROM MODERN_DATA.MODERN_DATA.PIZZA_CUSTOMER_ORDERS c
JOIN MODERN_DATA.MODERN_DATA.PIZZA_NAMES p ON c."pizza_id" = p."pizza_id"
JOIN MODERN_DATA.MODERN_DATA.PIZZA_RUNNER_ORDERS r ON c."order_id" = r."order_id"
WHERE p."pizza_name" IN ('Meatlovers', 'Vegetarian')
  AND (r."cancellation" = '' OR r."cancellation" IS NULL);