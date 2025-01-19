WITH
  country_mapping AS (
    SELECT 'US' AS covid_country_region, 'United States' AS wdi_country_name UNION ALL
    SELECT 'France', 'France' UNION ALL
    SELECT 'China', 'China' UNION ALL
    SELECT 'Italy', 'Italy' UNION ALL
    SELECT 'Spain', 'Spain' UNION ALL
    SELECT 'Germany', 'Germany' UNION ALL
    SELECT 'Iran', 'Iran, Islamic Rep.'
  ),
  covid_data AS (
    SELECT country_region, SUM(confirmed) AS total_confirmed_cases
    FROM `bigquery-public-data.covid19_jhu_csse.summary`
    WHERE date = '2020-04-20'
    GROUP BY country_region
  ),
  population_data AS (
    SELECT country_name, value AS population_2019
    FROM `bigquery-public-data.world_bank_wdi.indicators_data`
    WHERE indicator_code = 'SP.POP.TOTL' AND year = 2019
  )
SELECT
  m.covid_country_region AS Country,
  c.total_confirmed_cases AS Total_Confirmed_Cases,
  ROUND(c.total_confirmed_cases / p.population_2019 * 100000, 4) AS Cases_per_100000_people
FROM
  country_mapping m
  JOIN covid_data c ON m.covid_country_region = c.country_region
  JOIN population_data p ON m.wdi_country_name = p.country_name
ORDER BY
  Total_Confirmed_Cases DESC;