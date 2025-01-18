SELECT
  t2020."segment",
  t2020."unique_product_count_2020",
  ROUND(
    (
      (t2021."unique_product_count_2021" - t2020."unique_product_count_2020") * 100.0
      / t2020."unique_product_count_2020"
    ),
    4
  ) AS "percentage_increase"
FROM
  (
    SELECT
      hdp."segment",
      COUNT(DISTINCT sfm."product_code") AS "unique_product_count_2020"
    FROM
      EDUCATION_BUSINESS.EDUCATION_BUSINESS.HARDWARE_FACT_SALES_MONTHLY sfm
      JOIN EDUCATION_BUSINESS.EDUCATION_BUSINESS.HARDWARE_DIM_PRODUCT hdp
        ON sfm."product_code" = hdp."product_code"
    WHERE
      sfm."fiscal_year" = 2020
    GROUP BY
      hdp."segment"
  ) t2020
  JOIN (
    SELECT
      hdp."segment",
      COUNT(DISTINCT sfm."product_code") AS "unique_product_count_2021"
    FROM
      EDUCATION_BUSINESS.EDUCATION_BUSINESS.HARDWARE_FACT_SALES_MONTHLY sfm
      JOIN EDUCATION_BUSINESS.EDUCATION_BUSINESS.HARDWARE_DIM_PRODUCT hdp
        ON sfm."product_code" = hdp."product_code"
    WHERE
      sfm."fiscal_year" = 2021
    GROUP BY
      hdp."segment"
  ) t2021 ON t2020."segment" = t2021."segment"
ORDER BY
  "percentage_increase" DESC NULLS LAST;