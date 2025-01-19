WITH sales AS (
    SELECT p."segment", s."fiscal_year", COUNT(DISTINCT s."product_code") AS unique_products_sold
    FROM "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_FACT_SALES_MONTHLY" s
    INNER JOIN "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_DIM_PRODUCT" p
        ON s."product_code" = p."product_code"
    WHERE s."fiscal_year" IN (2020, 2021)
    GROUP BY p."segment", s."fiscal_year"
),
sales_pivot AS (
    SELECT
        s1."segment",
        MAX(CASE WHEN s1."fiscal_year" = 2020 THEN s1.unique_products_sold ELSE 0 END) AS unique_products_2020,
        MAX(CASE WHEN s1."fiscal_year" = 2021 THEN s1.unique_products_sold ELSE 0 END) AS unique_products_2021
    FROM sales s1
    GROUP BY s1."segment"
),
calculated AS (
    SELECT
        s."segment",
        s.unique_products_2020,
        s.unique_products_2021,
        CASE
            WHEN s.unique_products_2020 = 0 THEN NULL
            ELSE ROUND(((s.unique_products_2021 - s.unique_products_2020) * 100.0) / s.unique_products_2020, 4)
        END AS percentage_increase
    FROM sales_pivot s
)
SELECT
    "segment" AS "Segment",
    unique_products_2020 AS "Unique_Product_Count_2020"
FROM calculated
ORDER BY percentage_increase DESC NULLS LAST;