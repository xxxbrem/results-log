WITH picked_products AS (
    SELECT 
        "product_id", 
        SUM("qty") AS "total_picked_qty"
    FROM 
        "ORACLE_SQL"."ORACLE_SQL"."PICKING_LINE"
    WHERE 
        "order_id" = 421
    GROUP BY 
        "product_id"
),
purchases_fifo AS (
    SELECT 
        p."product_id", 
        p."id" AS "purchase_id", 
        p."purchased", 
        p."qty" AS "batch_qty",
        SUM(p."qty") OVER (
            PARTITION BY p."product_id" 
            ORDER BY p."purchased"
        ) AS "cumulative_qty"
    FROM 
        "ORACLE_SQL"."ORACLE_SQL"."PURCHASES" p
    INNER JOIN 
        picked_products pp ON p."product_id" = pp."product_id"
    ORDER BY 
        p."product_id", 
        p."purchased"
),
allocated_batches AS (
    SELECT
        p."product_id",
        p."purchase_id",
        p."purchased",
        p."batch_qty",
        CASE 
            WHEN pp."total_picked_qty" - COALESCE(LAG(p."cumulative_qty") OVER (
                PARTITION BY p."product_id" 
                ORDER BY p."purchased"), 0) >= p."batch_qty" THEN p."batch_qty"
            ELSE GREATEST(pp."total_picked_qty" - COALESCE(LAG(p."cumulative_qty") OVER (
                PARTITION BY p."product_id" 
                ORDER BY p."purchased"), 0), 0)
        END AS "picked_from_batch"
    FROM
        purchases_fifo p
    INNER JOIN
        picked_products pp ON p."product_id" = pp."product_id"
    WHERE
        p."cumulative_qty" - p."batch_qty" < pp."total_picked_qty"
),
average_units_per_product AS (
    SELECT
        "product_id",
        ROUND(AVG("picked_from_batch"), 4) AS "average_units_picked_per_batch"
    FROM
        allocated_batches
    GROUP BY
        "product_id"
)
SELECT 
    "product_id", 
    "average_units_picked_per_batch"
FROM 
    average_units_per_product;