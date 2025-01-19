SELECT
  product."segment" AS "Segment",
  COUNT(DISTINCT CASE WHEN sales."fiscal_year" = 2020 THEN sales."product_code" END) AS "UniqueProductCount2020",
  ROUND(
    (
      (COUNT(DISTINCT CASE WHEN sales."fiscal_year" = 2021 THEN sales."product_code" END) -
       COUNT(DISTINCT CASE WHEN sales."fiscal_year" = 2020 THEN sales."product_code" END)
      ) * 100.0
    ) / NULLIF(COUNT(DISTINCT CASE WHEN sales."fiscal_year" = 2020 THEN sales."product_code" END), 0),
    4
  ) AS "PercentageIncrease"
FROM
  EDUCATION_BUSINESS.EDUCATION_BUSINESS.HARDWARE_FACT_SALES_MONTHLY AS sales
INNER JOIN
  EDUCATION_BUSINESS.EDUCATION_BUSINESS.HARDWARE_DIM_PRODUCT AS product
ON
  sales."product_code" = product."product_code"
GROUP BY
  product."segment"
ORDER BY
  "PercentageIncrease" DESC NULLS LAST;