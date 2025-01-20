WITH total_crimes_per_year AS (
  SELECT
    `year`,
    SUM(`value`) AS total_crimes
  FROM
    `bigquery-public-data.london_crime.crime_by_lsoa`
  GROUP BY
    `year`
),
category_crimes_per_year AS (
  SELECT
    `year`,
    SUM(CASE WHEN `minor_category` = 'Other Theft' THEN `value` ELSE 0 END) AS Minor_category_1,
    SUM(CASE WHEN `minor_category` = 'Theft From Motor Vehicle' THEN `value` ELSE 0 END) AS Minor_category_2,
    SUM(CASE WHEN `minor_category` = 'Possession Of Drugs' THEN `value` ELSE 0 END) AS Minor_category_3,
    SUM(CASE WHEN `minor_category` = 'Burglary in a Dwelling' THEN `value` ELSE 0 END) AS Minor_category_4,
    SUM(CASE WHEN `minor_category` = 'Assault with Injury' THEN `value` ELSE 0 END) AS Minor_category_5
  FROM
    `bigquery-public-data.london_crime.crime_by_lsoa`
  GROUP BY
    `year`
)
SELECT
  c.`year` AS Year,
  ROUND(100 * c.Minor_category_1 / t.total_crimes, 4) AS `Minor_category_1`,
  ROUND(100 * c.Minor_category_2 / t.total_crimes, 4) AS `Minor_category_2`,
  ROUND(100 * c.Minor_category_3 / t.total_crimes, 4) AS `Minor_category_3`,
  ROUND(100 * c.Minor_category_4 / t.total_crimes, 4) AS `Minor_category_4`,
  ROUND(100 * c.Minor_category_5 / t.total_crimes, 4) AS `Minor_category_5`
FROM
  category_crimes_per_year c
JOIN
  total_crimes_per_year t
ON
  c.`year` = t.`year`
ORDER BY
  c.`year`;