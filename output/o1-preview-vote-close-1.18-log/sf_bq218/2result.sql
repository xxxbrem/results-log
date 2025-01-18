SELECT
  "item_number",
  "item_description",
  ROUND(
    (
      (
        SUM(CASE WHEN EXTRACT(YEAR FROM "date") = 2023 AND "sale_dollars" >= 0 THEN "sale_dollars" ELSE 0 END) -
        SUM(CASE WHEN EXTRACT(YEAR FROM "date") = 2022 AND "sale_dollars" >= 0 THEN "sale_dollars" ELSE 0 END)
      ) / NULLIF(SUM(CASE WHEN EXTRACT(YEAR FROM "date") = 2022 AND "sale_dollars" >= 0 THEN "sale_dollars" ELSE 0 END), 0)
    ) * 100,
    4
  ) AS "growth_percentage"
FROM
  "IOWA_LIQUOR_SALES"."IOWA_LIQUOR_SALES"."SALES"
GROUP BY
  "item_number",
  "item_description"
HAVING
  SUM(CASE WHEN EXTRACT(YEAR FROM "date") = 2022 AND "sale_dollars" >= 0 THEN "sale_dollars" ELSE 0 END) >= 1000
  AND SUM(CASE WHEN EXTRACT(YEAR FROM "date") = 2023 AND "sale_dollars" >= 0 THEN "sale_dollars" ELSE 0 END) > 0
ORDER BY
  "growth_percentage" DESC NULLS LAST
LIMIT 5;