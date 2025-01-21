WITH total_picked AS (
  SELECT 
    pl."product_id",
    SUM(pl."qty") AS "total_qty_picked"
  FROM ORACLE_SQL.ORACLE_SQL."PICKING_LINE" pl
  WHERE pl."order_id" = 421
  GROUP BY pl."product_id"
),
batches AS (
  SELECT 
    i."product_id",
    i."purchase_id",
    pur."purchased",
    i."qty" AS "batch_qty",
    ROW_NUMBER() OVER (PARTITION BY i."product_id" ORDER BY pur."purchased") AS "batch_no"
  FROM ORACLE_SQL.ORACLE_SQL."INVENTORY" i
  JOIN ORACLE_SQL.ORACLE_SQL."PURCHASES" pur ON i."purchase_id" = pur."id"
  WHERE i."product_id" IN (SELECT "product_id" FROM total_picked)
),
batches_cumulative AS (
  SELECT
    b.*,
    SUM(b."batch_qty") OVER (PARTITION BY b."product_id" ORDER BY b."batch_no") AS "cumulative_qty"
  FROM batches b
),
batches_used AS (
  SELECT
    bc."product_id",
    bc."batch_no",
    bc."batch_qty",
    bc."cumulative_qty",
    tp."total_qty_picked",
    CASE 
      WHEN bc."cumulative_qty" - bc."batch_qty" < tp."total_qty_picked" THEN 1 
      ELSE 0 
    END AS "batch_used",
    LEAST(
      bc."batch_qty", 
      GREATEST(tp."total_qty_picked" - (bc."cumulative_qty" - bc."batch_qty"), 0)
    ) AS "units_picked_from_batch"
  FROM batches_cumulative bc
  JOIN total_picked tp ON bc."product_id" = tp."product_id"
)
SELECT 
  bu."product_id",
  ROUND(AVG(bu."units_picked_from_batch"), 4) AS "average_units_picked_per_batch"
FROM batches_used bu
WHERE bu."batch_used" = 1
GROUP BY bu."product_id";