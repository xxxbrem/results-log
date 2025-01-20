WITH sales_2022 AS (
    SELECT
        "item_number",
        SUM("sale_dollars") AS total_sales_2022
    FROM
        IOWA_LIQUOR_SALES.IOWA_LIQUOR_SALES.SALES
    WHERE
        EXTRACT(YEAR FROM "date") = 2022
    GROUP BY
        "item_number"
),
sales_2023 AS (
    SELECT
        "item_number",
        SUM("sale_dollars") AS total_sales_2023
    FROM
        IOWA_LIQUOR_SALES.IOWA_LIQUOR_SALES.SALES
    WHERE
        EXTRACT(YEAR FROM "date") = 2023
    GROUP BY
        "item_number"
),
sales_growth AS (
    SELECT
        s2023."item_number",
        s2023.total_sales_2023,
        s2022.total_sales_2022,
        ((s2023.total_sales_2023 - s2022.total_sales_2022) / s2022.total_sales_2022) * 100 AS "growth_percentage"
    FROM
        sales_2023 s2023
    JOIN
        sales_2022 s2022 ON s2023."item_number" = s2022."item_number"
    WHERE
        s2022.total_sales_2022 > 0
)
SELECT
    sg."item_number",
    s."item_description",
    ROUND(sg."growth_percentage", 4) AS "growth_percentage"
FROM
    sales_growth sg
JOIN
    (
        SELECT 
            "item_number", 
            MAX("item_description") AS "item_description"
        FROM 
            IOWA_LIQUOR_SALES.IOWA_LIQUOR_SALES.SALES
        GROUP BY 
            "item_number"
    ) s ON sg."item_number" = s."item_number"
ORDER BY
    sg."growth_percentage" DESC NULLS LAST
LIMIT 5;