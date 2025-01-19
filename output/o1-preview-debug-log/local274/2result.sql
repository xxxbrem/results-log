WITH order_qty AS (
    SELECT product_id, SUM(qty) AS total_qty
    FROM picking_line
    WHERE order_id = 421
    GROUP BY product_id
),
inventory_batches AS (
    SELECT
        i.product_id,
        i.purchase_id,
        i.qty AS batch_qty,
        p.purchased AS purchase_date
    FROM inventory i
    JOIN purchases p ON i.purchase_id = p.id
),
inventory_batches_ordered AS (
    SELECT
        ib.*,
        ROW_NUMBER() OVER (
            PARTITION BY ib.product_id
            ORDER BY date(ib.purchase_date)
        ) AS rn
    FROM inventory_batches ib
),
inventory_batches_cumsum AS (
    SELECT
        ibo.*,
        SUM(ibo.batch_qty) OVER (
            PARTITION BY ibo.product_id
            ORDER BY date(ibo.purchase_date)
            ROWS UNBOUNDED PRECEDING
        ) AS cum_qty,
        oq.total_qty
    FROM inventory_batches_ordered ibo
    JOIN order_qty oq ON ibo.product_id = oq.product_id
),
batches_used AS (
    SELECT
        ibc.product_id,
        ibc.purchase_id,
        ibc.batch_qty,
        ibc.purchase_date,
        ibc.cum_qty,
        ibc.total_qty,
        CASE
            WHEN ibc.cum_qty <= ibc.total_qty THEN ibc.batch_qty
            WHEN ibc.cum_qty - ibc.batch_qty < ibc.total_qty THEN ibc.total_qty - (ibc.cum_qty - ibc.batch_qty)
            ELSE 0
        END AS units_picked
    FROM inventory_batches_cumsum ibc
    WHERE (ibc.cum_qty - ibc.batch_qty) < ibc.total_qty
),
average_units_picked AS (
    SELECT
        bu.product_id,
        AVG(bu.units_picked) AS avg_units_picked
    FROM batches_used bu
    GROUP BY bu.product_id
)
SELECT
    p.id AS product_id,
    p.name AS product_name,
    ROUND(a.avg_units_picked, 4) AS average_units_picked
FROM average_units_picked a
JOIN products p ON a.product_id = p.id
ORDER BY p.id;