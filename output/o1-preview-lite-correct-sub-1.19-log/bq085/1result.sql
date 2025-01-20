SELECT
  c.country_region AS Country,
  SUM(c.confirmed) AS Total_confirmed_cases,
  ROUND((SUM(c.confirmed) / p.population_2019) * 100000, 4) AS Cases_per_100k
FROM
  `bigquery-public-data.covid19_jhu_csse.summary` AS c
JOIN (
  SELECT
    CASE
      WHEN country_name = 'United States' THEN 'US'
      WHEN country_name = 'Iran, Islamic Rep.' THEN 'Iran'
      ELSE country_name
    END AS country_region,
    value AS population_2019
  FROM
    `bigquery-public-data.world_bank_wdi.indicators_data`
  WHERE
    indicator_code = 'SP.POP.TOTL' AND
    year = 2019 AND
    country_name IN ('United States', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran, Islamic Rep.')
) AS p
ON
  c.country_region = p.country_region
WHERE
  c.date = '2020-04-20' AND
  c.country_region IN ('US', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran')
GROUP BY
  Country,
  p.population_2019
ORDER BY
  Country;