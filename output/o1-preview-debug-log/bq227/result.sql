WITH top5_2008 AS (
  SELECT `minor_category`
  FROM `bigquery-public-data.london_crime.crime_by_lsoa`
  WHERE `year` = 2008
  GROUP BY `minor_category`
  ORDER BY SUM(`value`) DESC
  LIMIT 5
),
annual_totals AS (
  SELECT `year`, SUM(`value`) AS total_crimes
  FROM `bigquery-public-data.london_crime.crime_by_lsoa`
  GROUP BY `year`
),
category_totals AS (
  SELECT `year`, `minor_category`, SUM(`value`) AS category_crimes
  FROM `bigquery-public-data.london_crime.crime_by_lsoa`
  WHERE `minor_category` IN (SELECT `minor_category` FROM top5_2008)
  GROUP BY `year`, `minor_category`
)
SELECT
  a.`year`,
  ROUND(100 * SUM(CASE WHEN c.`minor_category` = 'Other Theft' THEN c.category_crimes ELSE 0 END) / a.total_crimes, 4) AS `Other_Theft`,
  ROUND(100 * SUM(CASE WHEN c.`minor_category` = 'Theft From Motor Vehicle' THEN c.category_crimes ELSE 0 END) / a.total_crimes, 4) AS `Theft_From_Motor_Vehicle`,
  ROUND(100 * SUM(CASE WHEN c.`minor_category` = 'Possession Of Drugs' THEN c.category_crimes ELSE 0 END) / a.total_crimes, 4) AS `Possession_Of_Drugs`,
  ROUND(100 * SUM(CASE WHEN c.`minor_category` = 'Burglary in a Dwelling' THEN c.category_crimes ELSE 0 END) / a.total_crimes, 4) AS `Burglary_in_a_Dwelling`,
  ROUND(100 * SUM(CASE WHEN c.`minor_category` = 'Assault with Injury' THEN c.category_crimes ELSE 0 END) / a.total_crimes, 4) AS `Assault_with_Injury`
FROM annual_totals a
LEFT JOIN category_totals c
  ON a.`year` = c.`year`
GROUP BY a.`year`, a.total_crimes
ORDER BY a.`year`;