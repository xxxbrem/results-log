WITH total_picked AS (
    SELECT "product_id", SUM("qty") AS total_picked_qty
    FROM ORACLE_SQL.ORACLE_SQL."PICKING_LINE"
    WHERE "order_id" = 421
    GROUP BY "product_id"
),
inventory_batches AS (
    SELECT
        inv."product_id",
        pur."id" AS "purchase_id",
        pur."purchased",
        inv."qty" AS "inventory_qty",
        SUM(inv."qty") OVER (PARTITION BY inv."product_id" ORDER BY pur."purchased" ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "cumulative_inv_qty"
    FROM
        ORACLE_SQL.ORACLE_SQL."INVENTORY" inv
    JOIN
        ORACLE_SQL.ORACLE_SQL."PURCHASES" pur ON inv."purchase_id" = pur."id"
    WHERE
        inv."product_id" IN (SELECT "product_id" FROM total_picked)
),
picked_per_batch AS (
    SELECT
        ib."product_id",
        ib."purchase_id",
        ib."purchased",
        ib."inventory_qty",
        ib."cumulative_inv_qty",
        tp.total_picked_qty,
        CASE
            WHEN (ib."cumulative_inv_qty" - ib."inventory_qty") < tp.total_picked_qty THEN
                LEAST(ib."inventory_qty", tp.total_picked_qty - (ib."cumulative_inv_qty" - ib."inventory_qty"))
            ELSE
                0
        END AS amount_picked_from_batch
    FROM
        inventory_batches ib
    JOIN
        total_picked tp ON ib."product_id" = tp."product_id"
),
final_result AS (
    SELECT
        ppb."product_id",
        pr."name" AS "product_name",
        ROUND(AVG(ppb.amount_picked_from_batch), 4) AS "average_qty_picked"
    FROM
        picked_per_batch ppb
    JOIN
        ORACLE_SQL.ORACLE_SQL."PRODUCTS" pr ON ppb."product_id" = pr."id"
    WHERE
        ppb.amount_picked_from_batch > 0
    GROUP BY
        ppb."product_id",
        pr."name"
)
SELECT * FROM final_result;