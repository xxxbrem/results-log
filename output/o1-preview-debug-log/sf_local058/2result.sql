WITH counts AS (
  SELECT dp."segment",
         COUNT(DISTINCT CASE WHEN fsm."fiscal_year" = 2020 THEN dp."product_code" END) AS "unique_product_count_2020",
         COUNT(DISTINCT CASE WHEN fsm."fiscal_year" = 2021 THEN dp."product_code" END) AS "unique_product_count_2021"
  FROM "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_DIM_PRODUCT" dp
  JOIN "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_FACT_SALES_MONTHLY" fsm
    ON dp."product_code" = fsm."product_code"
  GROUP BY dp."segment"
)
SELECT "segment",
       "unique_product_count_2020",
       "unique_product_count_2021",
       ROUND(
         CASE
           WHEN "unique_product_count_2020" = 0 THEN NULL
           ELSE (("unique_product_count_2021" - "unique_product_count_2020") * 100.0 / "unique_product_count_2020")
         END
       , 4) AS "percentage_increase"
FROM counts
ORDER BY "percentage_increase" DESC NULLS LAST;