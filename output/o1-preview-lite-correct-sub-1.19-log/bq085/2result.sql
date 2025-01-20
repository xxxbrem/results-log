SELECT
  conf.Country,
  conf.total_confirmed_cases,
  pop.population_2019,
  ROUND((conf.total_confirmed_cases / pop.population_2019) * 100000, 4) AS cases_per_100k
FROM (
  SELECT
    CASE
      WHEN c.country_or_region = 'US' THEN 'United States'
      WHEN c.country_or_region = 'Iran' THEN 'Iran, Islamic Rep.'
      ELSE c.country_or_region
    END AS Country,
    SUM(CAST(c.`_4_20_20` AS INT64)) AS total_confirmed_cases
  FROM
    `bigquery-public-data.covid19_jhu_csse.confirmed_cases` AS c
  WHERE
    c.country_or_region IN ('US', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran')
  GROUP BY
    Country
) AS conf
JOIN (
  SELECT
    p.country_name AS Country,
    MAX(CAST(p.value AS FLOAT64)) AS population_2019
  FROM
    `bigquery-public-data.world_bank_wdi.indicators_data` AS p
  WHERE
    p.indicator_code = 'SP.POP.TOTL'
    AND p.year = 2019
    AND p.country_name IN ('United States', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran, Islamic Rep.')
  GROUP BY
    p.country_name
) AS pop
ON conf.Country = pop.Country;