SELECT region,
       ROUND(
         IF(MOD(COUNT(*), 2) = 1,
           ARRAY_AGG(gdp ORDER BY gdp)[OFFSET(DIV(COUNT(*), 2))],
           (ARRAY_AGG(gdp ORDER BY gdp)[OFFSET(DIV(COUNT(*), 2) - 1)] +
            ARRAY_AGG(gdp ORDER BY gdp)[OFFSET(DIV(COUNT(*), 2))]) / 2
         ), 4) AS median_gdp
FROM (
  SELECT cs.region, id.value AS gdp
  FROM `bigquery-public-data.world_bank_wdi.indicators_data` AS id
  JOIN `bigquery-public-data.world_bank_wdi.country_summary` AS cs
  ON id.country_code = cs.country_code
  WHERE id.indicator_code = 'NY.GDP.MKTP.KD'
    AND id.year = 2019
    AND id.value IS NOT NULL
    AND cs.region IS NOT NULL
    AND cs.region != ''
    AND LENGTH(cs.country_code) = 3  -- Include only actual countries
)
GROUP BY region
ORDER BY median_gdp DESC
LIMIT 1;