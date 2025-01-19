WITH sales_2022 AS (
  SELECT
    item_description,
    SUM(sale_dollars) AS total_sales_2022
  FROM `bigquery-public-data.iowa_liquor_sales.sales`
  WHERE EXTRACT(YEAR FROM `date`) = 2022
  GROUP BY item_description
),
sales_2023 AS (
  SELECT
    item_description,
    SUM(sale_dollars) AS total_sales_2023
  FROM `bigquery-public-data.iowa_liquor_sales.sales`
  WHERE EXTRACT(YEAR FROM `date`) = 2023
  GROUP BY item_description
),
sales_growth AS (
  SELECT
    s2023.item_description,
    s2022.total_sales_2022,
    s2023.total_sales_2023
  FROM sales_2023 s2023
  INNER JOIN sales_2022 s2022 ON s2023.item_description = s2022.item_description
  WHERE s2022.total_sales_2022 > 0
)
SELECT
  item_description,
  ROUND(100.0 * (total_sales_2023 - total_sales_2022) / total_sales_2022, 4) AS growth_percentage
FROM sales_growth
ORDER BY growth_percentage DESC, item_description
LIMIT 5;