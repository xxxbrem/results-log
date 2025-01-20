WITH sales_2022 AS (
    SELECT
        `item_number`,
        SUM(`sale_dollars`) AS total_sales_2022
    FROM
        `bigquery-public-data.iowa_liquor_sales.sales`
    WHERE
        EXTRACT(YEAR FROM `date`) = 2022
    GROUP BY
        `item_number`
),
sales_2023 AS (
    SELECT
        `item_number`,
        `item_description`,
        SUM(`sale_dollars`) AS total_sales_2023
    FROM
        `bigquery-public-data.iowa_liquor_sales.sales`
    WHERE
        EXTRACT(YEAR FROM `date`) = 2023
    GROUP BY
        `item_number`, `item_description`
),
growth AS (
    SELECT
        s2023.`item_number`,
        s2023.`item_description`,
        SAFE_DIVIDE((s2023.total_sales_2023 - s2022.total_sales_2022), s2022.total_sales_2022) * 100 AS year_over_year_growth_percentage
    FROM
        sales_2023 s2023
    INNER JOIN
        sales_2022 s2022 ON s2023.`item_number` = s2022.`item_number`
    WHERE
        s2022.total_sales_2022 > 0
)
SELECT
    `item_number`,
    `item_description`,
    ROUND(year_over_year_growth_percentage, 4) AS year_over_year_growth_percentage
FROM
    growth
ORDER BY
    year_over_year_growth_percentage DESC
LIMIT 5;