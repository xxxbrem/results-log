SELECT
    sub."product_id",
    sub."aisle",
    sub."position",
    sub."quantity_to_pick"
FROM (
    SELECT
        ol."product_id",
        l."aisle",
        l."position",
        LEAST(ol."qty", il."qty") AS "quantity_to_pick",
        p."purchased",
        il."qty" AS "inventory_qty"
    FROM
        ORACLE_SQL.ORACLE_SQL."ORDERLINES" ol
    JOIN
        ORACLE_SQL.ORACLE_SQL."INVENTORY" il ON ol."product_id" = il."product_id"
    JOIN
        ORACLE_SQL.ORACLE_SQL."LOCATIONS" l ON il."location_id" = l."id"
    JOIN
        ORACLE_SQL.ORACLE_SQL."PURCHASES" p ON il."purchase_id" = p."id"
    WHERE
        ol."order_id" = 423
        AND l."warehouse" = 1
) sub
ORDER BY
    sub."purchased" ASC NULLS LAST,
    sub."inventory_qty" ASC NULLS LAST,
    sub."quantity_to_pick" DESC NULLS LAST
LIMIT 1;