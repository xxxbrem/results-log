SELECT
  i."product_id" AS "Product_ID",
  l."aisle" AS "Aisle",
  l."position" AS "Position",
  LEAST(i."qty", o."qty") AS "Quantity_to_Pick"
FROM
  "ORACLE_SQL"."ORACLE_SQL"."INVENTORY" i
  JOIN "ORACLE_SQL"."ORACLE_SQL"."LOCATIONS" l ON i."location_id" = l."id"
  JOIN "ORACLE_SQL"."ORACLE_SQL"."PURCHASES" p ON i."purchase_id" = p."id"
  JOIN "ORACLE_SQL"."ORACLE_SQL"."ORDERLINES" o ON i."product_id" = o."product_id" AND o."order_id" = 423
WHERE
  l."warehouse" = 1
ORDER BY
  p."purchased" ASC,
  i."qty" ASC
LIMIT 1;