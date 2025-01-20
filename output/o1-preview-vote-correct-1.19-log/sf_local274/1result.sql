WITH inventory_batches AS (
  SELECT
    i."product_id",
    i."purchase_id",
    i."id" AS "inventory_id",
    i."qty" AS "batch_qty",
    p."purchased",
    SUM(i."qty") OVER (
      PARTITION BY i."product_id"
      ORDER BY p."purchased", i."id"
      ROWS UNBOUNDED PRECEDING
    ) AS cumulative_inventory_qty,
    ROW_NUMBER() OVER (
      PARTITION BY i."product_id"
      ORDER BY p."purchased", i."id"
    ) AS batch_no
  FROM
    ORACLE_SQL.ORACLE_SQL.INVENTORY i
    JOIN ORACLE_SQL.ORACLE_SQL.PURCHASES p ON i."purchase_id" = p."id"
  WHERE
    i."product_id" IN (
      SELECT DISTINCT pl."product_id"
      FROM ORACLE_SQL.ORACLE_SQL.PICKING_LINE pl
      WHERE pl."order_id" = 421
    )
),
product_picks AS (
  SELECT
    pl."product_id",
    SUM(pl."qty") AS total_picked_qty
  FROM
    ORACLE_SQL.ORACLE_SQL.PICKING_LINE pl
  WHERE
    pl."order_id" = 421
  GROUP BY
    pl."product_id"
),
batches_allocation AS (
  SELECT
    ib."product_id",
    ib.batch_no,
    ib."inventory_id",
    ib."batch_qty",
    ib.cumulative_inventory_qty,
    ib.cumulative_inventory_qty - ib."batch_qty" AS cumulative_inventory_before_batch,
    pp.total_picked_qty,
    LEAST(
      ib."batch_qty",
      pp.total_picked_qty - GREATEST(0, ib.cumulative_inventory_qty - ib."batch_qty")
    ) AS units_picked_from_batch
  FROM
    inventory_batches ib
    JOIN product_picks pp ON ib."product_id" = pp."product_id"
  WHERE
    ib.cumulative_inventory_qty - ib."batch_qty" < pp.total_picked_qty
),
final_result AS (
  SELECT
    ba."product_id",
    AVG(ba.units_picked_from_batch) AS average_units_picked_per_batch
  FROM
    batches_allocation ba
  GROUP BY
    ba."product_id"
)
SELECT
  fr."product_id",
  ROUND(fr.average_units_picked_per_batch, 4) AS average_units_picked_per_batch
FROM
  final_result fr
ORDER BY
  fr."product_id";