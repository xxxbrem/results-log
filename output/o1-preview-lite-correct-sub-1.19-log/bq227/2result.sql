WITH top5_categories AS (
  SELECT `minor_category`
  FROM (
    SELECT `minor_category`, SUM(`value`) AS total_crimes
    FROM `bigquery-public-data.london_crime.crime_by_lsoa`
    WHERE `year` = 2008
    GROUP BY `minor_category`
    ORDER BY total_crimes DESC
    LIMIT 5
  )
),
annual_totals AS (
  SELECT `year`, SUM(`value`) AS total_crimes
  FROM `bigquery-public-data.london_crime.crime_by_lsoa`
  GROUP BY `year`
),
category_totals AS (
  SELECT `year`, `minor_category`, SUM(`value`) AS category_crimes
  FROM `bigquery-public-data.london_crime.crime_by_lsoa`
  WHERE `minor_category` IN (SELECT `minor_category` FROM top5_categories)
  GROUP BY `year`, `minor_category`
),
percentages AS (
  SELECT
    ct.`year`,
    ct.`minor_category`,
    (ct.`category_crimes` / annual.`total_crimes`) * 100 AS percentage_share
  FROM category_totals ct
  JOIN annual_totals annual ON ct.`year` = annual.`year`
)
SELECT
  p.`year` AS Year,
  ROUND(MAX(CASE WHEN p.`minor_category` = 'Other Theft' THEN p.`percentage_share` END), 4) AS `Other Theft`,
  ROUND(MAX(CASE WHEN p.`minor_category` = 'Theft From Motor Vehicle' THEN p.`percentage_share` END), 4) AS `Theft From Motor Vehicle`,
  ROUND(MAX(CASE WHEN p.`minor_category` = 'Possession Of Drugs' THEN p.`percentage_share` END), 4) AS `Possession Of Drugs`,
  ROUND(MAX(CASE WHEN p.`minor_category` = 'Burglary in a Dwelling' THEN p.`percentage_share` END), 4) AS `Burglary in a Dwelling`,
  ROUND(MAX(CASE WHEN p.`minor_category` = 'Assault with Injury' THEN p.`percentage_share` END), 4) AS `Assault with Injury`
FROM percentages p
GROUP BY p.`year`
ORDER BY p.`year`;