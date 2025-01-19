WITH sales_2022 AS (
    SELECT "item_description", SUM("sale_dollars") AS "total_sales_2022"
    FROM IOWA_LIQUOR_SALES.IOWA_LIQUOR_SALES.SALES
    WHERE "date" BETWEEN '2022-01-01' AND '2022-12-31'
    GROUP BY "item_description"
),
sales_2023 AS (
    SELECT "item_description", SUM("sale_dollars") AS "total_sales_2023"
    FROM IOWA_LIQUOR_SALES.IOWA_LIQUOR_SALES.SALES
    WHERE "date" BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY "item_description"
),
growth_calc AS (
    SELECT 
        s3."item_description",
        s2."total_sales_2022",
        s3."total_sales_2023",
        ROUND(((s3."total_sales_2023" - s2."total_sales_2022") / s2."total_sales_2022") * 100, 4) AS "growth_percentage"
    FROM sales_2022 s2
    JOIN sales_2023 s3 ON s2."item_description" = s3."item_description"
    WHERE s2."total_sales_2022" > 0
)
SELECT "item_description", "growth_percentage"
FROM growth_calc
ORDER BY "growth_percentage" DESC NULLS LAST
LIMIT 5;