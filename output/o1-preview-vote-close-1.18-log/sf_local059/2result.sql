WITH sales_2021 AS (
    SELECT "product_code", "sold_quantity"
    FROM "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_FACT_SALES_MONTHLY"
    WHERE TRY_TO_DATE("date", 'YYYY-MM-DD') BETWEEN '2021-01-01' AND '2021-12-31'
),
product_totals AS (
    SELECT "product_code", SUM("sold_quantity") AS total_quantity
    FROM sales_2021
    GROUP BY "product_code"
),
product_rankings AS (
    SELECT
        pt."product_code",
        pt.total_quantity,
        p."division",
        ROW_NUMBER() OVER (
            PARTITION BY p."division" 
            ORDER BY pt.total_quantity DESC NULLS LAST
        ) AS rn
    FROM product_totals pt
    JOIN "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_DIM_PRODUCT" p
        ON pt."product_code" = p."product_code"
),
top_products AS (
    SELECT "product_code", "division"
    FROM product_rankings
    WHERE rn <= 3
)
SELECT tp."division", ROUND(AVG(s."sold_quantity"), 4) AS "AverageQuantity"
FROM sales_2021 s
JOIN top_products tp
    ON s."product_code" = tp."product_code"
GROUP BY tp."division";