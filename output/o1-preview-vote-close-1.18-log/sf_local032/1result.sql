(
SELECT 'Highest number of distinct customers' AS "Criterion",
       OI."seller_id" AS "Seller_ID",
       COUNT(DISTINCT C."customer_unique_id") AS "Value"
FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDER_ITEMS OI
JOIN BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDERS O ON OI."order_id" = O."order_id"
JOIN BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_CUSTOMERS C ON O."customer_id" = C."customer_id"
WHERE O."order_status" = 'delivered'
GROUP BY OI."seller_id"
ORDER BY "Value" DESC NULLS LAST
LIMIT 1
)
UNION ALL
(
SELECT 'Highest profit' AS "Criterion",
       OI."seller_id" AS "Seller_ID",
       ROUND(SUM(OI."price"), 4) AS "Value"
FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDER_ITEMS OI
JOIN BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDERS O ON OI."order_id" = O."order_id"
WHERE O."order_status" = 'delivered'
GROUP BY OI."seller_id"
ORDER BY "Value" DESC NULLS LAST
LIMIT 1
)
UNION ALL
(
SELECT 'Highest number of distinct orders' AS "Criterion",
       OI."seller_id" AS "Seller_ID",
       COUNT(DISTINCT OI."order_id") AS "Value"
FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDER_ITEMS OI
JOIN BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDERS O ON OI."order_id" = O."order_id"
WHERE O."order_status" = 'delivered'
GROUP BY OI."seller_id"
ORDER BY "Value" DESC NULLS LAST
LIMIT 1
)
UNION ALL
(
SELECT 'Most 5-star ratings' AS "Criterion",
       OI."seller_id" AS "Seller_ID",
       COUNT(DISTINCT R."review_id") AS "Value"
FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDER_ITEMS OI
JOIN BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDERS O ON OI."order_id" = O."order_id"
JOIN BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDER_REVIEWS R ON OI."order_id" = R."order_id"
WHERE O."order_status" = 'delivered' AND R."review_score" = 5
GROUP BY OI."seller_id"
ORDER BY "Value" DESC NULLS LAST
LIMIT 1
);