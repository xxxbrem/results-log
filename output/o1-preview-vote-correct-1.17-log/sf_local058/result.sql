SELECT
    d."segment",
    COUNT(DISTINCT CASE WHEN s."fiscal_year" = 2020 THEN s."product_code" END) AS "unique_product_count_2020",
    COUNT(DISTINCT CASE WHEN s."fiscal_year" = 2021 THEN s."product_code" END) AS "unique_product_count_2021",
    ROUND(
        (
            (COUNT(DISTINCT CASE WHEN s."fiscal_year" = 2021 THEN s."product_code" END)
            - COUNT(DISTINCT CASE WHEN s."fiscal_year" = 2020 THEN s."product_code" END))
            / NULLIF(COUNT(DISTINCT CASE WHEN s."fiscal_year" = 2020 THEN s."product_code" END)::FLOAT, 0)
        ) * 100,
        4
    ) AS "percentage_increase"
FROM
    "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_FACT_SALES_MONTHLY" s
JOIN
    "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_DIM_PRODUCT" d
    ON s."product_code" = d."product_code"
WHERE
    s."fiscal_year" IN (2020, 2021)
GROUP BY
    d."segment"
ORDER BY
    "percentage_increase" DESC NULLS LAST;