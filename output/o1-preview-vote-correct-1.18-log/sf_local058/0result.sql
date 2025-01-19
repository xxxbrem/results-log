WITH "segments" AS (
  SELECT DISTINCT "segment"
  FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS.HARDWARE_DIM_PRODUCT
),
"product_counts" AS (
  SELECT
    p."segment",
    s."fiscal_year",
    COUNT(DISTINCT s."product_code") AS "product_count"
  FROM
    EDUCATION_BUSINESS.EDUCATION_BUSINESS.HARDWARE_FACT_SALES_MONTHLY s
  JOIN
    EDUCATION_BUSINESS.EDUCATION_BUSINESS.HARDWARE_DIM_PRODUCT p
  ON s."product_code" = p."product_code"
  GROUP BY
    p."segment",
    s."fiscal_year"
)
SELECT
  seg."segment" AS "Segment",
  COALESCE(pc20."product_count", 0) AS "Unique_Product_Count_2020",
  CASE
    WHEN COALESCE(pc20."product_count", 0) = 0 AND COALESCE(pc21."product_count", 0) > 0 THEN 100.0000
    WHEN COALESCE(pc20."product_count", 0) = 0 THEN 0.0000
    ELSE ROUND((COALESCE(pc21."product_count", 0) - pc20."product_count") / pc20."product_count" * 100, 4)
  END AS "Percentage_Increase_From_2020_To_2021"
FROM
  "segments" seg
LEFT JOIN
  (SELECT "segment", "product_count" FROM "product_counts" WHERE "fiscal_year" = 2020) pc20
ON seg."segment" = pc20."segment"
LEFT JOIN
  (SELECT "segment", "product_count" FROM "product_counts" WHERE "fiscal_year" = 2021) pc21
ON seg."segment" = pc21."segment"
ORDER BY
  "Percentage_Increase_From_2020_To_2021" DESC NULLS LAST
;