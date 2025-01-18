WITH sales_2021 AS (
    SELECT
        HMSM."product_code",
        HP."division",
        HMSM."sold_quantity"
    FROM
        "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_FACT_SALES_MONTHLY" HMSM
        JOIN "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_DIM_PRODUCT" HP
            ON HMSM."product_code" = HP."product_code"
    WHERE
        HMSM."date" LIKE '2021%'
),
total_sales_per_product AS (
    SELECT
        "division",
        "product_code",
        SUM("sold_quantity") AS "total_sold_quantity"
    FROM
        sales_2021
    GROUP BY
        "division", "product_code"
),
ranked_products AS (
    SELECT
        "division",
        "product_code",
        "total_sold_quantity",
        RANK() OVER (
            PARTITION BY "division" 
            ORDER BY "total_sold_quantity" DESC NULLS LAST
        ) AS "product_rank"
    FROM
        total_sales_per_product
),
top3_products AS (
    SELECT
        "division",
        "product_code"
    FROM
        ranked_products
    WHERE
        "product_rank" <= 3
),
sales_top3 AS (
    SELECT
        s."division",
        s."sold_quantity"
    FROM
        sales_2021 s
        JOIN top3_products t
            ON s."division" = t."division" AND s."product_code" = t."product_code"
)
SELECT
    s."division" AS "Division",
    ROUND(AVG(s."sold_quantity"), 4) AS "Average_Quantity_Sold"
FROM
    sales_top3 s
GROUP BY
    s."division"
ORDER BY
    s."division";