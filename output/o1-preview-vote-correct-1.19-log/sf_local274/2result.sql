WITH total_picked AS (
  SELECT
    pl."product_id",
    SUM(pl."qty") AS "total_picked_qty"
  FROM
    "ORACLE_SQL"."ORACLE_SQL"."PICKING_LINE" pl
  WHERE
    pl."order_id" = 421
  GROUP BY
    pl."product_id"
),
inventory_batches AS (
  SELECT
    i."product_id",
    pu."purchased",
    i."qty",
    ROW_NUMBER() OVER (
      PARTITION BY i."product_id"
      ORDER BY pu."purchased", i."purchase_id"
    ) AS "batch_number"
  FROM
    "ORACLE_SQL"."ORACLE_SQL"."INVENTORY" i
    JOIN "ORACLE_SQL"."ORACLE_SQL"."PURCHASES" pu ON i."purchase_id" = pu."id"
  WHERE
    i."product_id" IN (
      SELECT "product_id"
      FROM total_picked
    )
),
inventory_cumulative AS (
  SELECT
    ib."product_id",
    ib."batch_number",
    ib."qty",
    SUM(ib."qty") OVER (
      PARTITION BY ib."product_id"
      ORDER BY ib."batch_number"
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS "cumulative_qty"
  FROM
    inventory_batches ib
),
batches_used AS (
  SELECT DISTINCT
    ic."product_id",
    ic."batch_number"
  FROM
    inventory_cumulative ic
    JOIN total_picked tp ON ic."product_id" = tp."product_id"
  WHERE
    ic."cumulative_qty" >= tp."total_picked_qty"
),
min_batches_needed AS (
  SELECT
    "product_id",
    MIN("batch_number") AS "batches_used"
  FROM
    batches_used
  GROUP BY
    "product_id"
)
SELECT
  tp."product_id",
  ROUND(tp."total_picked_qty" / mbn."batches_used", 4) AS "average_units_picked_per_batch"
FROM
  total_picked tp
  JOIN min_batches_needed mbn ON tp."product_id" = mbn."product_id";