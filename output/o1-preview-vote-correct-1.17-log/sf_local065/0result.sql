SELECT
  SUM(
    CASE
      WHEN c."pizza_id" = 1 THEN 12
      WHEN c."pizza_id" = 2 THEN 10
      ELSE 0
    END
    +
    CASE
      WHEN c."extras" IS NULL OR c."extras" = '' THEN 0
      ELSE ARRAY_SIZE(SPLIT(c."extras", ',')) * 1
    END
  ) AS "Total_income"
FROM
  "MODERN_DATA"."MODERN_DATA"."PIZZA_CUSTOMER_ORDERS" c
JOIN
  "MODERN_DATA"."MODERN_DATA"."PIZZA_RUNNER_ORDERS" r
ON
  c."order_id" = r."order_id"
WHERE
  c."pizza_id" IN (1, 2)
  AND (r."cancellation" IS NULL OR r."cancellation" = '');