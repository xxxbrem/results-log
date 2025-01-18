WITH product_events AS (
    SELECT
        E."visit_id",
        E."cookie_id",
        E."event_type",
        E."sequence_number",
        E."event_time",
        P."product_id"
    FROM
        BANK_SALES_TRADING.BANK_SALES_TRADING.SHOPPING_CART_EVENTS E
        JOIN BANK_SALES_TRADING.BANK_SALES_TRADING.SHOPPING_CART_PAGE_HIERARCHY P ON E."page_id" = P."page_id"
    WHERE
        E."page_id" NOT IN (1, 2, 12, 13)
        AND P."product_id" IS NOT NULL
),
events_agg AS (
    SELECT
        "product_id",
        SUM(CASE WHEN "event_type" = 1 THEN 1 ELSE 0 END) AS number_of_views,
        SUM(CASE WHEN "event_type" = 2 THEN 1 ELSE 0 END) AS number_added_to_cart
    FROM
        product_events
    GROUP BY
        "product_id"
),
purchase_events AS (
    SELECT
        E."visit_id",
        E."cookie_id",
        E."sequence_number" AS "purchase_seq"
    FROM
        BANK_SALES_TRADING.BANK_SALES_TRADING.SHOPPING_CART_EVENTS E
    WHERE
        E."event_type" = 3  -- Purchase
),
purchased_products AS (
    SELECT
        A."product_id",
        COUNT(*) AS number_of_purchases
    FROM
        product_events A
        JOIN purchase_events P ON A."visit_id" = P."visit_id"
            AND A."cookie_id" = P."cookie_id"
            AND A."sequence_number" < P."purchase_seq"
    WHERE
        A."event_type" = 2  -- Add to Cart
    GROUP BY
        A."product_id"
)

SELECT
    E."product_id",
    E.number_of_views,
    E.number_added_to_cart,
    (E.number_added_to_cart - COALESCE(P.number_of_purchases, 0)) AS number_left_in_cart_without_purchase,
    COALESCE(P.number_of_purchases, 0) AS number_of_purchases
FROM
    events_agg E
    LEFT JOIN purchased_products P ON E."product_id" = P."product_id"
ORDER BY
    E."product_id";