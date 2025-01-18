WITH sales_by_item AS (
  SELECT 
    "item_number",
    "item_description",
    SUM(CASE WHEN EXTRACT(YEAR FROM "date") = 2022 THEN "sale_dollars" ELSE 0 END) AS "sales_2022",
    SUM(CASE WHEN EXTRACT(YEAR FROM "date") = 2023 THEN "sale_dollars" ELSE 0 END) AS "sales_2023"
  FROM IOWA_LIQUOR_SALES.IOWA_LIQUOR_SALES.SALES
  WHERE "date" BETWEEN '2022-01-01' AND '2023-12-31'
  GROUP BY "item_number", "item_description"
)
SELECT 
  "item_number",
  "item_description",
  ROUND((("sales_2023" - "sales_2022") / NULLIF("sales_2022", 0)) * 100, 4) AS "growth_percentage"
FROM sales_by_item
WHERE "sales_2022" <> 0 AND "sales_2023" <> 0
ORDER BY "growth_percentage" DESC NULLS LAST
LIMIT 5;