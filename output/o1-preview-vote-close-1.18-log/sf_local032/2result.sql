SELECT "Criterion", "Seller_ID", "Value"
FROM (
    (SELECT 'Highest_number_of_distinct_customers' AS "Criterion",
            OI."seller_id" AS "Seller_ID",
            CAST(COUNT(DISTINCT OO."customer_id") AS FLOAT) AS "Value"
     FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDER_ITEMS" AS OI
     JOIN BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDERS" AS OO
         ON OI."order_id" = OO."order_id"
     WHERE OO."order_status" = 'delivered'
     GROUP BY OI."seller_id"
     ORDER BY "Value" DESC NULLS LAST
     LIMIT 1)
    UNION ALL
    (SELECT 'Highest_profit' AS "Criterion",
            OI."seller_id" AS "Seller_ID",
            ROUND(SUM(OI."price" - OI."freight_value"), 4) AS "Value"
     FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDER_ITEMS" AS OI
     JOIN BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDERS" AS OO
         ON OI."order_id" = OO."order_id"
     WHERE OO."order_status" = 'delivered'
     GROUP BY OI."seller_id"
     ORDER BY "Value" DESC NULLS LAST
     LIMIT 1)
    UNION ALL
    (SELECT 'Highest_number_of_distinct_orders' AS "Criterion",
            OI."seller_id" AS "Seller_ID",
            CAST(COUNT(DISTINCT OI."order_id") AS FLOAT) AS "Value"
     FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDER_ITEMS" AS OI
     JOIN BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDERS" AS OO
         ON OI."order_id" = OO."order_id"
     WHERE OO."order_status" = 'delivered'
     GROUP BY OI."seller_id"
     ORDER BY "Value" DESC NULLS LAST
     LIMIT 1)
    UNION ALL
    (SELECT 'Most_5_star_ratings' AS "Criterion",
            OI."seller_id" AS "Seller_ID",
            CAST(COUNT(DISTINCT ORV."review_id") AS FLOAT) AS "Value"
     FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDER_ITEMS" AS OI
     JOIN BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDERS" AS OO
         ON OI."order_id" = OO."order_id"
     JOIN BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDER_REVIEWS" AS ORV
         ON OO."order_id" = ORV."order_id"
     WHERE OO."order_status" = 'delivered' AND ORV."review_score" = 5
     GROUP BY OI."seller_id"
     ORDER BY "Value" DESC NULLS LAST
     LIMIT 1)
) AS final
ORDER BY "Criterion";