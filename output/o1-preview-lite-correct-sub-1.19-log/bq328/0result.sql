SELECT 
  c.region AS Region, 
  ROUND(APPROX_QUANTILES(d.value, 2)[OFFSET(1)], 4) AS Median_GDP
FROM `bigquery-public-data.world_bank_wdi.indicators_data` AS d
JOIN `bigquery-public-data.world_bank_wdi.country_summary` AS c
  ON d.country_code = c.country_code
WHERE 
  d.indicator_code = 'NY.GDP.MKTP.KD' 
  AND d.year = 2019
  AND c.region IS NOT NULL AND c.region != ''
GROUP BY 
  Region
ORDER BY 
  Median_GDP DESC
LIMIT 1;