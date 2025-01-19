WITH viewed AS (
  SELECT
    p."product_id",
    COUNT(*) AS "viewed_count"
  FROM
    BANK_SALES_TRADING.BANK_SALES_TRADING."SHOPPING_CART_EVENTS" e
    JOIN BANK_SALES_TRADING.BANK_SALES_TRADING."SHOPPING_CART_PAGE_HIERARCHY" p
      ON e."page_id" = p."page_id"
  WHERE
    e."event_type" = 1  -- Page View
    AND e."page_id" NOT IN (1, 2, 12, 13)
  GROUP BY
    p."product_id"
),
added_to_cart AS (
  SELECT
    p."product_id",
    COUNT(*) AS "added_to_cart_count"
  FROM
    BANK_SALES_TRADING.BANK_SALES_TRADING."SHOPPING_CART_EVENTS" e
    JOIN BANK_SALES_TRADING.BANK_SALES_TRADING."SHOPPING_CART_PAGE_HIERARCHY" p
      ON e."page_id" = p."page_id"
  WHERE
    e."event_type" = 2  -- Add to Cart
    AND e."page_id" NOT IN (1, 2, 12, 13)
  GROUP BY
    p."product_id"
),
purchased AS (
  SELECT
    atc."product_id",
    COUNT(DISTINCT atc."cookie_id") AS "purchase_count"
  FROM (
    SELECT DISTINCT
      e."cookie_id",
      p."product_id"
    FROM
      BANK_SALES_TRADING.BANK_SALES_TRADING."SHOPPING_CART_EVENTS" e
      JOIN BANK_SALES_TRADING.BANK_SALES_TRADING."SHOPPING_CART_PAGE_HIERARCHY" p
        ON e."page_id" = p."page_id"
    WHERE
      e."event_type" = 2  -- Add to Cart
      AND e."page_id" NOT IN (1, 2, 12, 13)
  ) atc
  INNER JOIN (
    SELECT DISTINCT
      e."cookie_id"
    FROM
      BANK_SALES_TRADING.BANK_SALES_TRADING."SHOPPING_CART_EVENTS" e
    WHERE
      e."event_type" = 3  -- Purchase
  ) pur ON atc."cookie_id" = pur."cookie_id"
  GROUP BY
    atc."product_id"
),
left_in_cart AS (
  SELECT
    atc."product_id",
    COUNT(DISTINCT atc."cookie_id") AS "left_in_cart_count"
  FROM (
    SELECT DISTINCT
      e."cookie_id",
      p."product_id"
    FROM
      BANK_SALES_TRADING.BANK_SALES_TRADING."SHOPPING_CART_EVENTS" e
      JOIN BANK_SALES_TRADING.BANK_SALES_TRADING."SHOPPING_CART_PAGE_HIERARCHY" p
        ON e."page_id" = p."page_id"
    WHERE
      e."event_type" = 2  -- Add to Cart
      AND e."page_id" NOT IN (1, 2, 12, 13)
  ) atc
  LEFT JOIN (
    SELECT DISTINCT
      e."cookie_id"
    FROM
      BANK_SALES_TRADING.BANK_SALES_TRADING."SHOPPING_CART_EVENTS" e
    WHERE
      e."event_type" = 3  -- Purchase
  ) pur ON atc."cookie_id" = pur."cookie_id"
  WHERE
    pur."cookie_id" IS NULL  -- No corresponding purchase
  GROUP BY
    atc."product_id"
)
SELECT
  v."product_id",
  v."viewed_count",
  a."added_to_cart_count",
  COALESCE(l."left_in_cart_count", 0) AS "left_in_cart_count",
  COALESCE(p."purchase_count", 0) AS "purchase_count"
FROM
  viewed v
  LEFT JOIN added_to_cart a ON v."product_id" = a."product_id"
  LEFT JOIN left_in_cart l ON v."product_id" = l."product_id"
  LEFT JOIN purchased p ON v."product_id" = p."product_id"
ORDER BY
  v."product_id";