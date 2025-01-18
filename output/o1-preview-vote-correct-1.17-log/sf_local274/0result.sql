WITH total_picked AS (
    SELECT "product_id", SUM("qty") AS "total_picked_qty"
    FROM "ORACLE_SQL"."ORACLE_SQL"."PICKING_LINE"
    WHERE "order_id" = 421
    GROUP BY "product_id"
),
inventory_fifo AS (
    SELECT
        inv."product_id",
        inv."purchase_id",
        inv."qty" AS "inventory_qty",
        pur."purchased",
        SUM(inv."qty") OVER (
            PARTITION BY inv."product_id" 
            ORDER BY pur."purchased" 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS "cumulative_qty"
    FROM "ORACLE_SQL"."ORACLE_SQL"."INVENTORY" AS inv
    JOIN "ORACLE_SQL"."ORACLE_SQL"."PURCHASES" AS pur 
        ON inv."purchase_id" = pur."id"
    WHERE inv."product_id" IN (
        SELECT "product_id"
        FROM "ORACLE_SQL"."ORACLE_SQL"."PICKING_LINE"
        WHERE "order_id" = 421
        GROUP BY "product_id"
    )
),
allocated_inventory AS (
    SELECT
        inv."product_id",
        inv."purchase_id",
        inv."inventory_qty",
        inv."purchased",
        inv."cumulative_qty",
        t."total_picked_qty",
        CASE
            WHEN inv."cumulative_qty" <= t."total_picked_qty" THEN inv."inventory_qty"
            WHEN inv."cumulative_qty" - inv."inventory_qty" < t."total_picked_qty" THEN t."total_picked_qty" - (inv."cumulative_qty" - inv."inventory_qty")
            ELSE 0
        END AS "qty_used"
    FROM inventory_fifo AS inv
    JOIN total_picked AS t ON inv."product_id" = t."product_id"
),
batches_used AS (
    SELECT
        "product_id",
        COUNT(DISTINCT "purchase_id") AS "batches_used",
        SUM("qty_used") AS "total_qty_used"
    FROM allocated_inventory
    WHERE "qty_used" > 0
    GROUP BY "product_id"
)
SELECT
    t."product_id",
    p."name" AS "product_name",
    ROUND(t."total_picked_qty" / b."batches_used", 4) AS "average_units_picked"
FROM total_picked AS t
JOIN batches_used AS b ON t."product_id" = b."product_id"
JOIN "ORACLE_SQL"."ORACLE_SQL"."PRODUCTS" AS p ON t."product_id" = p."id";