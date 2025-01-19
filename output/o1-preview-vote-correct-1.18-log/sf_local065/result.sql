SELECT
  CAST(SUM(base_price + num_extras) AS DECIMAL(10,4)) AS "Total_Income"
FROM
(
  SELECT
    pc."order_id",
    pc."pizza_id",
    pn."pizza_name",
    pc."extras",
    CASE
      WHEN pn."pizza_name" = 'Meatlovers' THEN 12
      WHEN pn."pizza_name" = 'Vegetarian' THEN 10
      ELSE 0
    END AS base_price,
    CASE
      WHEN pc."extras" IS NULL OR pc."extras" = '' THEN 0
      ELSE REGEXP_COUNT(pc."extras", ',') + 1
    END AS num_extras
  FROM MODERN_DATA.MODERN_DATA.PIZZA_CUSTOMER_ORDERS pc
  JOIN MODERN_DATA.MODERN_DATA.PIZZA_RUNNER_ORDERS pr
    ON pc."order_id" = pr."order_id"
  JOIN MODERN_DATA.MODERN_DATA.PIZZA_NAMES pn
    ON pc."pizza_id" = pn."pizza_id"
  WHERE pr."cancellation" IS NULL OR pr."cancellation" = ''
)