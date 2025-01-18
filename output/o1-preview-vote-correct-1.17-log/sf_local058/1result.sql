SELECT 
    p."segment" AS "segment_name",
    COUNT(DISTINCT CASE WHEN s."fiscal_year" = 2020 THEN s."product_code" END) AS "unique_product_count_2020",
    COUNT(DISTINCT CASE WHEN s."fiscal_year" = 2021 THEN s."product_code" END) AS "unique_product_count_2021",
    ROUND(
        (
            (
                COUNT(DISTINCT CASE WHEN s."fiscal_year" = 2021 THEN s."product_code" END) - 
                COUNT(DISTINCT CASE WHEN s."fiscal_year" = 2020 THEN s."product_code" END)
            ) * 100.0
        ) / NULLIF(COUNT(DISTINCT CASE WHEN s."fiscal_year" = 2020 THEN s."product_code" END), 0)
        , 4
    ) AS "percentage_increase"
FROM "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_FACT_SALES_MONTHLY" s
JOIN "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_DIM_PRODUCT" p
  ON s."product_code" = p."product_code"
WHERE s."fiscal_year" IN (2020, 2021)
GROUP BY p."segment"
ORDER BY "percentage_increase" DESC NULLS LAST;