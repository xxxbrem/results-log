WITH sales_2022 AS (
  SELECT "item_number", SUM("sale_dollars") AS "total_sales_2022"
  FROM "IOWA_LIQUOR_SALES"."IOWA_LIQUOR_SALES"."SALES"
  WHERE EXTRACT(YEAR FROM "date") = 2022
  GROUP BY "item_number"
),
sales_2023 AS (
  SELECT "item_number", SUM("sale_dollars") AS "total_sales_2023"
  FROM "IOWA_LIQUOR_SALES"."IOWA_LIQUOR_SALES"."SALES"
  WHERE EXTRACT(YEAR FROM "date") = 2023
  GROUP BY "item_number"
)
SELECT 
  s2."item_number",
  i."item_description",
  ROUND(((s2."total_sales_2023" - s1."total_sales_2022") / s1."total_sales_2022") * 100, 4) AS "year_over_year_growth_percentage"
FROM sales_2022 s1
INNER JOIN sales_2023 s2 ON s1."item_number" = s2."item_number"
JOIN (
  SELECT DISTINCT "item_number", "item_description"
  FROM "IOWA_LIQUOR_SALES"."IOWA_LIQUOR_SALES"."SALES"
) i ON s1."item_number" = i."item_number"
WHERE s1."total_sales_2022" > 0
ORDER BY "year_over_year_growth_percentage" DESC NULLS LAST
LIMIT 5;