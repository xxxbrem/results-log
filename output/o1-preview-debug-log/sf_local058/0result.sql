SELECT
    sub."segment",
    sub."unique_product_count_2020",
    ROUND(
        (
            (sub."unique_product_count_2021" - sub."unique_product_count_2020") * 100.0
        ) / NULLIF(sub."unique_product_count_2020", 0),
        4
    ) AS "percentage_increase"
FROM
    (
        SELECT
            t."segment",
            COUNT(DISTINCT CASE WHEN SUBSTRING(s."date", 1, 4) = '2020' THEN s."product_code" END) AS "unique_product_count_2020",
            COUNT(DISTINCT CASE WHEN SUBSTRING(s."date", 1, 4) = '2021' THEN s."product_code" END) AS "unique_product_count_2021"
        FROM
            "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_DIM_PRODUCT" t
        JOIN
            "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_FACT_SALES_MONTHLY" s
            ON t."product_code" = s."product_code"
        WHERE
            SUBSTRING(s."date", 1, 4) IN ('2020', '2021')
        GROUP BY
            t."segment"
    ) sub
ORDER BY
    "percentage_increase" DESC NULLS LAST;