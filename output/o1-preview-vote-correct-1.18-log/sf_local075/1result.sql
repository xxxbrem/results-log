WITH views AS (
    SELECT
        ph."product_id",
        COUNT(*) AS "view_count"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS" e
    JOIN
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_PAGE_HIERARCHY" ph
            ON e."page_id" = ph."page_id"
    JOIN
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENT_IDENTIFIER" ei
            ON e."event_type" = ei."event_type"
    WHERE
        ei."event_name" = 'Page View'
        AND ph."page_id" NOT IN (1, 2, 12, 13)
    GROUP BY
        ph."product_id"
),
add_to_cart AS (
    SELECT
        ph."product_id",
        COUNT(*) AS "add_to_cart_count"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS" e
    JOIN
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_PAGE_HIERARCHY" ph
            ON e."page_id" = ph."page_id"
    JOIN
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENT_IDENTIFIER" ei
            ON e."event_type" = ei."event_type"
    WHERE
        ei."event_name" = 'Add to Cart'
        AND ph."page_id" NOT IN (1, 2, 12, 13)
    GROUP BY
        ph."product_id"
),
purchases AS (
    SELECT
        atc."product_id",
        COUNT(DISTINCT atc."visit_id") AS "purchase_count"
    FROM
        (
            SELECT DISTINCT
                e."visit_id",
                ph."product_id"
            FROM
                "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS" e
            JOIN
                "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_PAGE_HIERARCHY" ph
                    ON e."page_id" = ph."page_id"
            JOIN
                "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENT_IDENTIFIER" ei
                    ON e."event_type" = ei."event_type"
            WHERE
                ei."event_name" = 'Add to Cart'
                AND ph."page_id" NOT IN (1, 2, 12, 13)
        ) atc
    JOIN
        (
            SELECT DISTINCT
                e."visit_id"
            FROM
                "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS" e
            JOIN
                "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENT_IDENTIFIER" ei
                    ON e."event_type" = ei."event_type"
            WHERE
                ei."event_name" = 'Purchase'
        ) p
        ON atc."visit_id" = p."visit_id"
    GROUP BY
        atc."product_id"
)
SELECT
    v."product_id",
    v."view_count",
    COALESCE(a."add_to_cart_count", 0) AS "add_to_cart_count",
    COALESCE(a."add_to_cart_count", 0) - COALESCE(p."purchase_count", 0) AS "left_in_cart_count",
    COALESCE(p."purchase_count", 0) AS "purchase_count"
FROM
    views v
LEFT JOIN
    add_to_cart a ON v."product_id" = a."product_id"
LEFT JOIN
    purchases p ON v."product_id" = p."product_id";