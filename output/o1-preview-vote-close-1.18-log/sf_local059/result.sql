WITH Total_Sales AS (
    SELECT p."division",
           s."product_code",
           SUM(s."sold_quantity") AS "total_quantity"
    FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS."HARDWARE_FACT_SALES_MONTHLY" s
    JOIN EDUCATION_BUSINESS.EDUCATION_BUSINESS."HARDWARE_DIM_PRODUCT" p
        ON s."product_code" = p."product_code"
    WHERE s."fiscal_year" = 2021
    GROUP BY p."division", s."product_code"
),
Top3_Sales AS (
    SELECT "division", "product_code", "total_quantity",
        DENSE_RANK() OVER (
            PARTITION BY "division" 
            ORDER BY "total_quantity" DESC NULLS LAST
        ) AS dr
    FROM Total_Sales
),
Top3_Per_Division AS (
    SELECT "division", "product_code", "total_quantity"
    FROM Top3_Sales
    WHERE dr <= 3
),
Average_Quantity AS (
    SELECT "division", AVG("total_quantity") AS "average_quantity_sold"
    FROM Top3_Per_Division
    GROUP BY "division"
)
SELECT "division", ROUND("average_quantity_sold", 4) AS "average_quantity_sold"
FROM Average_Quantity;