WITH sales_2022 AS (
  SELECT "item_number", "item_description", SUM("sale_dollars") AS "total_sales_2022"
  FROM "IOWA_LIQUOR_SALES"."IOWA_LIQUOR_SALES"."SALES"
  WHERE YEAR("date") = 2022
  GROUP BY "item_number", "item_description"
),
sales_2023 AS (
  SELECT "item_number", "item_description", SUM("sale_dollars") AS "total_sales_2023"
  FROM "IOWA_LIQUOR_SALES"."IOWA_LIQUOR_SALES"."SALES"
  WHERE YEAR("date") = 2023
  GROUP BY "item_number", "item_description"
),
sales_combined AS (
  SELECT 
    COALESCE(s23."item_number", s22."item_number") AS "item_number",
    COALESCE(s23."item_description", s22."item_description") AS "item_description",
    COALESCE(s23."total_sales_2023", 0) AS "total_sales_2023",
    COALESCE(s22."total_sales_2022", 0) AS "total_sales_2022"
  FROM sales_2023 s23
  FULL OUTER JOIN sales_2022 s22
    ON s23."item_number" = s22."item_number" AND s23."item_description" = s22."item_description"
)
SELECT 
  "item_number",
  "item_description",
  ROUND((( "total_sales_2023" - "total_sales_2022" ) / "total_sales_2022" ) * 100, 4) AS "year_over_year_growth_percentage"
FROM sales_combined
WHERE "total_sales_2022" > 0
ORDER BY "year_over_year_growth_percentage" DESC NULLS LAST
LIMIT 5;