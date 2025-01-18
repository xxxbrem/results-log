SELECT
    pl."product_id",
    p."name" AS "product_name",
    ROUND(AVG(pl."qty"), 4) AS "average_qty_picked"
FROM
    ORACLE_SQL.ORACLE_SQL."PICKING_LINE" pl
    JOIN ORACLE_SQL.ORACLE_SQL."PRODUCTS" p
      ON pl."product_id" = p."id"
WHERE
    pl."order_id" = 421
GROUP BY
    pl."product_id",
    p."name";