SELECT
  oi."seller_id" AS "Seller_ID",
  COUNT(*) AS "Number_of_5-star_Ratings"
FROM
  "BRAZILIAN_E_COMMERCE"."BRAZILIAN_E_COMMERCE"."OLIST_ORDER_ITEMS" AS oi
INNER JOIN
  "BRAZILIAN_E_COMMERCE"."BRAZILIAN_E_COMMERCE"."OLIST_ORDERS" AS o
  ON oi."order_id" = o."order_id"
INNER JOIN
  "BRAZILIAN_E_COMMERCE"."BRAZILIAN_E_COMMERCE"."OLIST_ORDER_REVIEWS" AS orv
  ON o."order_id" = orv."order_id"
WHERE
  o."order_status" = 'delivered'
  AND orv."review_score" = 5
GROUP BY
  oi."seller_id"
ORDER BY
  "Number_of_5-star_Ratings" DESC NULLS LAST
LIMIT
  1;