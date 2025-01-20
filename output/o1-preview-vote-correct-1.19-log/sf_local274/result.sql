WITH picked_totals AS (
    SELECT "product_id", SUM("qty") AS "total_qty_picked"
    FROM ORACLE_SQL.ORACLE_SQL.PICKING_LINE
    WHERE "order_id" = 421
    GROUP BY "product_id"
),
purchases_ordered AS (
    SELECT
        inv."product_id",
        pur."id" AS "purchase_id",
        pur."purchased",
        inv."qty" AS "inventory_qty",
        SUM(inv."qty") OVER (
            PARTITION BY inv."product_id"
            ORDER BY pur."purchased", pur."id"
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS "cumulative_inventory"
    FROM ORACLE_SQL.ORACLE_SQL.INVENTORY inv
    JOIN ORACLE_SQL.ORACLE_SQL.PURCHASES pur
      ON inv."purchase_id" = pur."id"
    WHERE inv."product_id" IN (
        SELECT DISTINCT "product_id"
        FROM ORACLE_SQL.ORACLE_SQL.PICKING_LINE
        WHERE "order_id" = 421
    )
),
fifo_allocation AS (
    SELECT
        po."product_id",
        po."purchase_id",
        po."purchased",
        po."inventory_qty",
        po."cumulative_inventory",
        pt."total_qty_picked",
        CASE
            WHEN po."cumulative_inventory" - po."inventory_qty" < pt."total_qty_picked"
                 AND po."cumulative_inventory" >= pt."total_qty_picked"
            THEN pt."total_qty_picked" - (po."cumulative_inventory" - po."inventory_qty")
            WHEN po."cumulative_inventory" <= pt."total_qty_picked"
            THEN po."inventory_qty"
            ELSE 0
        END AS "allocated_qty"
    FROM purchases_ordered po
    JOIN picked_totals pt
      ON po."product_id" = pt."product_id"
),
batches_used AS (
    SELECT
        "product_id",
        COUNT(CASE WHEN "allocated_qty" > 0 THEN 1 END) AS "batches_used",
        SUM("allocated_qty") AS "total_allocated_qty"
    FROM fifo_allocation
    WHERE "allocated_qty" > 0
    GROUP BY "product_id"
)
SELECT
    "product_id",
    ROUND("total_allocated_qty" / "batches_used", 4) AS "average_units_picked_per_batch"
FROM batches_used;