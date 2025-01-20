WITH avg_birth_rates AS (
  SELECT 
    ind.country_code,
    cs.short_name AS Country,
    cs.region AS Region,
    AVG(ind.value) AS avg_birth_rate
  FROM 
    `bigquery-public-data.world_bank_wdi.indicators_data` AS ind
  JOIN 
    `bigquery-public-data.world_bank_wdi.country_summary` AS cs
    ON ind.country_code = cs.country_code
  WHERE 
    ind.indicator_code = 'SP.DYN.CBRT.IN'
    AND ind.year BETWEEN 1980 AND 1989
    AND cs.income_group = 'High income'
    AND cs.region != ''
  GROUP BY 
    ind.country_code, cs.short_name, cs.region
)
SELECT 
  Country, 
  Region, 
  ROUND(avg_birth_rate, 4) AS Average_Crude_Birth_Rate
FROM avg_birth_rates
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY Region 
  ORDER BY avg_birth_rate DESC, Country ASC
) = 1
ORDER BY Region;