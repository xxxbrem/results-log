WITH products AS (
    SELECT
        p."product_id",
        p."page_name" AS "product_name"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_PAGE_HIERARCHY" p
    WHERE
        p."page_id" NOT IN (1, 2, 12, 13)
        AND p."product_id" IS NOT NULL
),
views AS (
    SELECT
        p."product_id",
        COUNT(*) AS "views"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS" e
    JOIN
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_PAGE_HIERARCHY" p
        ON e."page_id" = p."page_id"
    WHERE
        e."event_type" = 1
        AND e."page_id" NOT IN (1, 2, 12, 13)
    GROUP BY
        p."product_id"
),
additions_to_cart AS (
    SELECT
        p."product_id",
        COUNT(*) AS "additions_to_cart"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS" e
    JOIN
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_PAGE_HIERARCHY" p
        ON e."page_id" = p."page_id"
    WHERE
        e."event_type" = 2
        AND e."page_id" NOT IN (1, 2, 12, 13)
    GROUP BY
        p."product_id"
),
add_to_cart_events AS (
    SELECT DISTINCT
        e."visit_id",
        p."product_id"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS" e
    JOIN
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_PAGE_HIERARCHY" p
        ON e."page_id" = p."page_id"
    WHERE
        e."event_type" = 2
        AND e."page_id" NOT IN (1, 2, 12, 13)
        AND p."product_id" IS NOT NULL
),
purchase_visits AS (
    SELECT DISTINCT
        e."visit_id"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS" e
    WHERE
        e."event_type" = 3
),
actual_purchases AS (
    SELECT
        a."product_id",
        COUNT(*) AS "actual_purchases"
    FROM
        add_to_cart_events a
    INNER JOIN purchase_visits p ON a."visit_id" = p."visit_id"
    GROUP BY
        a."product_id"
),
left_in_cart AS (
    SELECT
        a."product_id",
        COUNT(*) AS "left_in_cart_without_purchase"
    FROM
        add_to_cart_events a
    LEFT JOIN purchase_visits p ON a."visit_id" = p."visit_id"
    WHERE
        p."visit_id" IS NULL
    GROUP BY
        a."product_id"
)
SELECT
    p."product_id",
    p."product_name",
    COALESCE(v."views", 0) AS "views",
    COALESCE(a."additions_to_cart", 0) AS "additions_to_cart",
    COALESCE(l."left_in_cart_without_purchase", 0) AS "left_in_cart_without_purchase",
    COALESCE(ap."actual_purchases", 0) AS "actual_purchases"
FROM
    products p
LEFT JOIN views v ON p."product_id" = v."product_id"
LEFT JOIN additions_to_cart a ON p."product_id" = a."product_id"
LEFT JOIN left_in_cart l ON p."product_id" = l."product_id"
LEFT JOIN actual_purchases ap ON p."product_id" = ap."product_id"
ORDER BY
    p."product_id";