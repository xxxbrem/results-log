SELECT ROUND(SUM(
    CASE WHEN n."pizza_name" = 'Meatlovers' THEN 12
         WHEN n."pizza_name" = 'Vegetarian' THEN 10
         ELSE 0 END
    +
    CASE
        WHEN c."extras" IS NULL OR TRIM(c."extras") = '' THEN 0
        ELSE REGEXP_COUNT(c."extras", '[^,]+')
    END
), 4) AS "total_income"
FROM MODERN_DATA.MODERN_DATA.PIZZA_CUSTOMER_ORDERS c
JOIN MODERN_DATA.MODERN_DATA.PIZZA_NAMES n
    ON c."pizza_id" = n."pizza_id"
JOIN MODERN_DATA.MODERN_DATA.PIZZA_RUNNER_ORDERS r
    ON c."order_id" = r."order_id"
WHERE (r."cancellation" IS NULL OR TRIM(r."cancellation") = '')
  AND n."pizza_name" IN ('Meatlovers', 'Vegetarian');