WITH sales_per_item AS (
  SELECT 
    item_number, 
    item_description, 
    EXTRACT(YEAR FROM `date`) AS year, 
    SUM(sale_dollars) AS total_sales
  FROM 
    `bigquery-public-data.iowa_liquor_sales.sales`
  WHERE 
    EXTRACT(YEAR FROM `date`) IN (2022, 2023)
  GROUP BY 
    item_number, 
    item_description, 
    year
),
sales_comparison AS (
  SELECT 
    s2023.item_number,
    s2023.item_description,
    ROUND(
      ((s2023.total_sales - s2022.total_sales) / s2022.total_sales) * 100,
      4
    ) AS year_over_year_growth_percentage
  FROM 
    sales_per_item AS s2023
  INNER JOIN 
    sales_per_item AS s2022
  ON 
    s2023.item_number = s2022.item_number
    AND s2023.item_description = s2022.item_description
  WHERE 
    s2023.year = 2023
    AND s2022.year = 2022
    AND s2022.total_sales >= 1000
    AND ((s2023.total_sales - s2022.total_sales) / s2022.total_sales) * 100 > 0
)
SELECT
  item_number,
  item_description,
  year_over_year_growth_percentage
FROM
  sales_comparison
ORDER BY
  year_over_year_growth_percentage DESC,
  item_number ASC
LIMIT 5;