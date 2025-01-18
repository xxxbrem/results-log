WITH sales_2022 AS (
    SELECT "item_description", SUM("sale_dollars") AS sales_2022
    FROM IOWA_LIQUOR_SALES.IOWA_LIQUOR_SALES.SALES
    WHERE "date" BETWEEN '2022-01-01' AND '2022-12-31'
    GROUP BY "item_description"
),
sales_2023 AS (
    SELECT "item_description", SUM("sale_dollars") AS sales_2023
    FROM IOWA_LIQUOR_SALES.IOWA_LIQUOR_SALES.SALES
    WHERE "date" BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY "item_description"
)
SELECT s23."item_description",
       ROUND(((s23.sales_2023 - s22.sales_2022) / s22.sales_2022) * 100, 4) AS "Growth_percentage"
FROM sales_2023 s23
JOIN sales_2022 s22 ON s23."item_description" = s22."item_description"
WHERE s22.sales_2022 != 0
ORDER BY "Growth_percentage" DESC NULLS LAST
LIMIT 5;