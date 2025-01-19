WITH event_counts AS (
  SELECT
    p."product_id",
    SUM(CASE WHEN e."event_type" = 1 THEN 1 ELSE 0 END) AS "views",
    SUM(CASE WHEN e."event_type" = 2 THEN 1 ELSE 0 END) AS "add_to_cart"
  FROM
    "shopping_cart_events" e
  JOIN
    "shopping_cart_page_hierarchy" p ON e."page_id" = p."page_id"
  WHERE
    e."page_id" NOT IN (1, 2, 12, 13)
  GROUP BY
    p."product_id"
),
purchased_visits AS (
  SELECT DISTINCT
    "visit_id"
  FROM
    "shopping_cart_events"
  WHERE
    "event_type" = 3
),
carts AS (
  SELECT DISTINCT
    e."visit_id",
    p."product_id"
  FROM
    "shopping_cart_events" e
  JOIN
    "shopping_cart_page_hierarchy" p ON e."page_id" = p."page_id"
  WHERE
    e."page_id" NOT IN (1, 2, 12, 13)
    AND e."event_type" = 2
),
cart_status AS (
  SELECT
    c."product_id",
    COUNT(*) AS "added_to_cart_count",
    SUM(CASE WHEN pv."visit_id" IS NOT NULL THEN 1 ELSE 0 END) AS "purchases",
    SUM(CASE WHEN pv."visit_id" IS NULL THEN 1 ELSE 0 END) AS "left_in_cart_without_purchase"
  FROM
    carts c
  LEFT JOIN
    purchased_visits pv ON c."visit_id" = pv."visit_id"
  GROUP BY
    c."product_id"
)
SELECT
  ec."product_id",
  ec."views",
  ec."add_to_cart",
  cs."left_in_cart_without_purchase",
  cs."purchases"
FROM
  event_counts ec
LEFT JOIN
  cart_status cs ON ec."product_id" = cs."product_id";