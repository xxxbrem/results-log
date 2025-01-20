WITH sales_per_year AS (
  SELECT "item_number", "item_description", EXTRACT(YEAR FROM "date") AS "year", SUM("sale_dollars") AS "total_sales"
  FROM IOWA_LIQUOR_SALES.IOWA_LIQUOR_SALES.SALES
  GROUP BY "item_number", "item_description", EXTRACT(YEAR FROM "date")
)
SELECT s2023."item_number", s2023."item_description",
  ROUND(((s2023."total_sales" - s2022."total_sales") / NULLIF(s2022."total_sales", 0)) * 100, 4) AS "growth_percentage"
FROM sales_per_year s2022
JOIN sales_per_year s2023 ON s2022."item_number" = s2023."item_number"
WHERE s2022."year" = 2022 AND s2023."year" = 2023 AND s2022."total_sales" > 0
ORDER BY "growth_percentage" DESC NULLS LAST
LIMIT 5;