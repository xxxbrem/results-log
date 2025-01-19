WITH picked_products AS (
    SELECT product_id, SUM(qty) AS total_units_picked
    FROM picking_line
    WHERE order_id = 421
    GROUP BY product_id
),
inventory_batches AS (
    SELECT 
        i.product_id, 
        i.qty, 
        pu.purchased, 
        i.id,
        ROW_NUMBER() OVER (PARTITION BY i.product_id ORDER BY pu.purchased ASC) AS batch_no
    FROM inventory i
    JOIN purchases pu ON i.purchase_id = pu.id
    JOIN picked_products pp ON pp.product_id = i.product_id
),
inventory_cumulative AS (
    SELECT 
        product_id, 
        qty, 
        purchased, 
        id, 
        batch_no,
        SUM(qty) OVER (PARTITION BY product_id ORDER BY batch_no) AS cumulative_qty
    FROM inventory_batches
),
batches_used AS (
    SELECT 
        ic.product_id, 
        MIN(ic.batch_no) AS batches_used
    FROM inventory_cumulative ic
    JOIN picked_products pp ON pp.product_id = ic.product_id
    WHERE ic.cumulative_qty >= pp.total_units_picked
    GROUP BY ic.product_id
)
SELECT 
    pp.product_id, 
    p.name AS product_name,
    ROUND(pp.total_units_picked * 1.0 / bu.batches_used, 4) AS average_units_picked
FROM picked_products pp
JOIN batches_used bu ON pp.product_id = bu.product_id
JOIN products p ON pp.product_id = p.id;