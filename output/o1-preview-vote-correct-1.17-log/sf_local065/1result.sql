SELECT SUM(
    CASE
        WHEN o."pizza_id" = 1 THEN 12
        WHEN o."pizza_id" = 2 THEN 10
        ELSE 0
    END
    +
    CASE
        WHEN o."extras" IS NULL OR o."extras" = '' THEN 0
        ELSE ARRAY_SIZE(SPLIT(o."extras", ',')) * 1
    END
) AS "total_income"
FROM "MODERN_DATA"."MODERN_DATA"."PIZZA_CUSTOMER_ORDERS" o
JOIN "MODERN_DATA"."MODERN_DATA"."PIZZA_RUNNER_ORDERS" r
    ON o."order_id" = r."order_id"
WHERE (r."cancellation" IS NULL OR r."cancellation" = '')
  AND o."pizza_id" IN (1, 2);