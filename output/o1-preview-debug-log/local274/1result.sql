WITH
picking_totals AS (
    SELECT product_id, SUM(qty) as total_picked
    FROM picking_line
    WHERE order_id = 421
    GROUP BY product_id
),
purchases_ordered AS (
    SELECT p.product_id, p.id as purchase_id, p.purchased, p.qty as purchase_qty
    FROM purchases p
    JOIN picking_totals pt ON p.product_id = pt.product_id
    WHERE p.purchased <= (SELECT ordered FROM orders WHERE id = 421)
    ORDER BY p.product_id, p.purchased
),
purchases_with_cumsum AS (
    SELECT 
        po.product_id,
        po.purchase_id,
        po.purchased,
        po.purchase_qty,
        SUM(po.purchase_qty) OVER (PARTITION BY po.product_id ORDER BY po.purchased ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cumulative_qty
    FROM purchases_ordered po
),
purchases_used AS (
    SELECT 
        pwc.product_id,
        pwc.purchase_id,
        pwc.purchase_qty,
        pwc.cumulative_qty,
        pt.total_picked,
        CASE 
            WHEN pwc.cumulative_qty - pwc.purchase_qty >= pt.total_picked THEN 0
            WHEN pwc.cumulative_qty >= pt.total_picked THEN pt.total_picked - (pwc.cumulative_qty - pwc.purchase_qty)
            ELSE pwc.purchase_qty
        END as qty_used
    FROM purchases_with_cumsum pwc
    JOIN picking_totals pt ON pwc.product_id = pt.product_id
    WHERE pwc.cumulative_qty - pwc.purchase_qty < pt.total_picked
),
product_avg AS (
    SELECT 
        product_id,
        SUM(qty_used) as total_units_picked,
        COUNT(*) as batches_used,
        SUM(qty_used)*1.0 / COUNT(*) as average_units_picked
    FROM purchases_used
    GROUP BY product_id
)
SELECT p.id as product_id, p.name as product_name, ROUND(pa.average_units_picked, 4) as average_units_picked
FROM product_avg pa
JOIN products p ON pa.product_id = p.id
ORDER BY p.id