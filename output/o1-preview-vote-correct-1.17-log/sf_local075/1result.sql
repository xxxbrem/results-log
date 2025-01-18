WITH AddToCartEvents AS (
    SELECT
        e."visit_id",
        ph."product_id"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS" e
    JOIN
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_PAGE_HIERARCHY" ph
        ON e."page_id" = ph."page_id"
    WHERE
        e."event_type" = 2
        AND e."page_id" NOT IN (1, 2, 12, 13)
        AND ph."product_id" IS NOT NULL
),
PurchaseVisits AS (
    SELECT DISTINCT
        "visit_id"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS"
    WHERE
        "event_type" = 3
),
ProductViews AS (
    SELECT
        ph."product_id",
        COUNT(*) AS "number_times_viewed"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_EVENTS" e
    JOIN
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_PAGE_HIERARCHY" ph
        ON e."page_id" = ph."page_id"
    WHERE
        e."event_type" = 1
        AND e."page_id" NOT IN (1, 2, 12, 13)
        AND ph."product_id" IS NOT NULL
    GROUP BY
        ph."product_id"
),
FinalCounts AS (
    SELECT
        atc."product_id",
        COUNT(*) AS "number_times_added_to_cart",
        SUM(CASE WHEN p."visit_id" IS NULL THEN 1 ELSE 0 END) AS "number_times_left_in_cart_without_purchase",
        SUM(CASE WHEN p."visit_id" IS NOT NULL THEN 1 ELSE 0 END) AS "count_of_actual_purchases"
    FROM
        AddToCartEvents atc
    LEFT JOIN
        PurchaseVisits p
        ON atc."visit_id" = p."visit_id"
    GROUP BY
        atc."product_id"
)
SELECT
    fc."product_id",
    ph."page_name" AS "product_name",
    pv."number_times_viewed",
    fc."number_times_added_to_cart",
    fc."number_times_left_in_cart_without_purchase",
    fc."count_of_actual_purchases"
FROM
    FinalCounts fc
JOIN
    "BANK_SALES_TRADING"."BANK_SALES_TRADING"."SHOPPING_CART_PAGE_HIERARCHY" ph
    ON fc."product_id" = ph."product_id"
LEFT JOIN
    ProductViews pv
    ON fc."product_id" = pv."product_id"
GROUP BY
    fc."product_id",
    ph."page_name",
    pv."number_times_viewed",
    fc."number_times_added_to_cart",
    fc."number_times_left_in_cart_without_purchase",
    fc."count_of_actual_purchases"
ORDER BY
    fc."product_id";