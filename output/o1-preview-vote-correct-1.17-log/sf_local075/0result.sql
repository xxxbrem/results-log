WITH views AS (
  SELECT CAST(p."product_id" AS INT) AS "product_id", COUNT(*) AS "number_times_viewed"
  FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS" e
  JOIN "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_PAGE_HIERARCHY" p
    ON e."page_id" = p."page_id"
  WHERE e."event_type" = 1  -- Page View
    AND e."page_id" NOT IN (1, 2, 12, 13)
  GROUP BY "product_id"
),
add_to_cart AS (
  SELECT CAST(p."product_id" AS INT) AS "product_id", COUNT(*) AS "number_times_added_to_cart"
  FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS" e
  JOIN "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_PAGE_HIERARCHY" p
    ON e."page_id" = p."page_id"
  WHERE e."event_type" = 2  -- Add to Cart
    AND e."page_id" NOT IN (1, 2, 12, 13)
  GROUP BY "product_id"
),
purchases AS (
  SELECT CAST(a."product_id" AS INT) AS "product_id", COUNT(*) AS "actual_purchase_count"
  FROM (
    SELECT DISTINCT e."visit_id", p."product_id"
    FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS" e
    JOIN "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_PAGE_HIERARCHY" p
      ON e."page_id" = p."page_id"
    WHERE e."event_type" = 2  -- Add to Cart
      AND e."page_id" NOT IN (1, 2, 12, 13)
  ) a
  JOIN (
    SELECT DISTINCT "visit_id"
    FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS"
    WHERE "event_type" = 3  -- Purchase
      AND "page_id" = 13
  ) p ON a."visit_id" = p."visit_id"
  GROUP BY "product_id"
)
SELECT
  COALESCE(v."product_id", a."product_id", p."product_id") AS "product_id",
  COALESCE(v."number_times_viewed", 0) AS "number_times_viewed",
  COALESCE(a."number_times_added_to_cart", 0) AS "number_times_added_to_cart",
  COALESCE(a."number_times_added_to_cart", 0) - COALESCE(p."actual_purchase_count", 0) AS "number_times_left_in_cart_without_purchase",
  COALESCE(p."actual_purchase_count", 0) AS "actual_purchase_count"
FROM views v
FULL OUTER JOIN add_to_cart a ON v."product_id" = a."product_id"
FULL OUTER JOIN purchases p ON COALESCE(v."product_id", a."product_id") = p."product_id"
ORDER BY "product_id";