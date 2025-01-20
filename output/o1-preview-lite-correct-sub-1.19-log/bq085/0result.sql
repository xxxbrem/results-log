SELECT 
  cp.country,
  tc.total_confirmed_cases,
  ROUND((tc.total_confirmed_cases / cp.population_2019) * 100000, 4) AS cases_per_100k
FROM
  (
    SELECT
      CASE
        WHEN cc.country_or_region = 'US' THEN 'United States'
        WHEN cc.country_or_region = 'Iran' THEN 'Iran, Islamic Rep.'
        ELSE cc.country_or_region
      END AS country,
      SUM(CAST(cc.`_4_20_20` AS INT64)) AS total_confirmed_cases
    FROM `bigquery-public-data.covid19_jhu_csse.confirmed_cases` AS cc
    WHERE cc.country_or_region IN ('US', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran')
    GROUP BY country
  ) AS tc
JOIN
  (
    SELECT
      country_name AS country,
      SUM(CASE WHEN year = 2019 AND indicator_code = 'SP.POP.TOTL' THEN value ELSE 0 END) AS population_2019
    FROM `bigquery-public-data.world_bank_wdi.indicators_data`
    WHERE indicator_code = 'SP.POP.TOTL'
      AND year = 2019
      AND country_name IN ('United States', 'France', 'China', 'Italy', 'Spain', 'Germany', 'Iran, Islamic Rep.')
    GROUP BY country
  ) AS cp
ON tc.country = cp.country
ORDER BY tc.total_confirmed_cases DESC;