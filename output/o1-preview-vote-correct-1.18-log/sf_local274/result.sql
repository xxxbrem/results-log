WITH
Picked_Products AS (
    SELECT
        "product_id",
        SUM("qty") AS "total_picked_qty"
    FROM "ORACLE_SQL"."ORACLE_SQL"."PICKING_LINE"
    WHERE "order_id" = 421
    GROUP BY "product_id"
),
Inventory_Batches AS (
    SELECT
        i."product_id",
        p."id" AS "purchase_id",
        p."purchased",
        i."qty" AS "inventory_qty",
        ROW_NUMBER() OVER (PARTITION BY i."product_id" ORDER BY p."purchased", p."id") AS "batch_number"
    FROM
        "ORACLE_SQL"."ORACLE_SQL"."INVENTORY" i
    INNER JOIN
        "ORACLE_SQL"."ORACLE_SQL"."PURCHASES" p
        ON i."purchase_id" = p."id"
    WHERE i."product_id" IN (SELECT "product_id" FROM Picked_Products)
),
Inventory_Cumulative AS (
    SELECT
        ib."product_id",
        ib."batch_number",
        ib."inventory_qty",
        SUM(ib."inventory_qty") OVER (
            PARTITION BY ib."product_id"
            ORDER BY ib."batch_number"
            ROWS UNBOUNDED PRECEDING
        ) AS "cum_inventory_qty"
    FROM Inventory_Batches ib
),
Batches_Used AS (
    SELECT
        ic."product_id",
        MIN(ic."batch_number") AS "batches_used"
    FROM
        Inventory_Cumulative ic
    INNER JOIN
        Picked_Products pp
        ON ic."product_id" = pp."product_id"
    WHERE
        ic."cum_inventory_qty" >= pp."total_picked_qty"
    GROUP BY
        ic."product_id"
),
Final_Calc AS (
    SELECT
        pp."product_id",
        ROUND(pp."total_picked_qty" / bu."batches_used", 4) AS "avg_qty"
    FROM
        Picked_Products pp
    INNER JOIN
        Batches_Used bu
        ON pp."product_id" = bu."product_id"
)
SELECT "product_id", "avg_qty"
FROM Final_Calc;