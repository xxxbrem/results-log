SELECT
  c.`year` AS `Year`,
  ROUND(SUM(IF(c.`minor_category` = 'Other Theft', c.`value`, 0)) / t.`year_total` * 100, 4) AS `Other Theft`,
  ROUND(SUM(IF(c.`minor_category` = 'Theft From Motor Vehicle', c.`value`, 0)) / t.`year_total` * 100, 4) AS `Theft From Motor Vehicle`,
  ROUND(SUM(IF(c.`minor_category` = 'Possession Of Drugs', c.`value`, 0)) / t.`year_total` * 100, 4) AS `Possession Of Drugs`,
  ROUND(SUM(IF(c.`minor_category` = 'Burglary in a Dwelling', c.`value`, 0)) / t.`year_total` * 100, 4) AS `Burglary in a Dwelling`,
  ROUND(SUM(IF(c.`minor_category` = 'Assault with Injury', c.`value`, 0)) / t.`year_total` * 100, 4) AS `Assault with Injury`
FROM `bigquery-public-data.london_crime.crime_by_lsoa` AS c
JOIN (
  SELECT `year`, SUM(`value`) AS `year_total`
  FROM `bigquery-public-data.london_crime.crime_by_lsoa`
  GROUP BY `year`
) AS t
ON c.`year` = t.`year`
GROUP BY c.`year`, t.`year_total`
ORDER BY c.`year` ASC;