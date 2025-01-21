WITH picked_batches AS (
    SELECT
        pl."product_id",
        pl."qty",
        pur."purchased" AS "purchase_date"
    FROM
        "ORACLE_SQL"."ORACLE_SQL"."PICKING_LINE" pl
    JOIN
        "ORACLE_SQL"."ORACLE_SQL"."INVENTORY" inv
            ON pl."product_id" = inv."product_id" AND pl."location_id" = inv."location_id"
    JOIN
        "ORACLE_SQL"."ORACLE_SQL"."PURCHASES" pur
            ON inv."purchase_id" = pur."id"
    WHERE
        pl."order_id" = 421
)
SELECT
    "product_id",
    ROUND(AVG("qty"), 4) AS "average_units_picked_per_batch"
FROM
    picked_batches
GROUP BY
    "product_id"
ORDER BY
    "product_id";