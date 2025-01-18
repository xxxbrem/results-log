WITH temp AS (
    SELECT 
        i."product_id", 
        l."aisle", 
        l."position",
        LEAST(o."qty", i."qty") AS "quantity_to_pick",
        p."purchased",
        i."qty" AS "inventory_qty"
    FROM "ORACLE_SQL"."ORACLE_SQL"."ORDERLINES" o
    JOIN "ORACLE_SQL"."ORACLE_SQL"."INVENTORY" i ON o."product_id" = i."product_id"
    JOIN "ORACLE_SQL"."ORACLE_SQL"."LOCATIONS" l ON i."location_id" = l."id"
    JOIN "ORACLE_SQL"."ORACLE_SQL"."PURCHASES" p ON i."purchase_id" = p."id"
    WHERE o."order_id" = 423
      AND l."warehouse" = 1
)
SELECT "product_id", "aisle", "position", ROUND("quantity_to_pick", 4) AS "quantity_to_pick"
FROM temp
ORDER BY "quantity_to_pick" DESC NULLS LAST, "purchased" ASC NULLS LAST, "inventory_qty" ASC NULLS LAST
LIMIT 1;