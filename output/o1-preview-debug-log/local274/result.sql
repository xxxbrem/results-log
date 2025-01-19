SELECT pl."product_id", ROUND(AVG(pl."qty"), 4) AS "average_units_picked"
FROM "picking_line" pl
WHERE pl."order_id" = 421
GROUP BY pl."product_id";