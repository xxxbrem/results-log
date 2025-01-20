SELECT
    sub."item_number",
    sub."item_description",
    ROUND(((sub."sales_2023" - sub."sales_2022") / sub."sales_2022") * 100, 4) AS "growth_percentage"
FROM (
    SELECT
        s."item_number",
        MAX(s."item_description") AS "item_description",
        SUM(CASE WHEN EXTRACT(YEAR FROM s."date") = 2022 THEN s."sale_dollars" ELSE 0 END) AS "sales_2022",
        SUM(CASE WHEN EXTRACT(YEAR FROM s."date") = 2023 THEN s."sale_dollars" ELSE 0 END) AS "sales_2023"
    FROM "IOWA_LIQUOR_SALES"."IOWA_LIQUOR_SALES"."SALES" s
    WHERE EXTRACT(YEAR FROM s."date") IN (2022, 2023)
    GROUP BY s."item_number"
) sub
WHERE sub."sales_2022" > 0
ORDER BY "growth_percentage" DESC NULLS LAST
LIMIT 5;