SELECT t.region, t.short_name AS country, ROUND(t.avg_birth_rate, 4) AS AverageBirthRate
FROM (
  SELECT cs.region, cs.short_name, AVG(id.value) AS avg_birth_rate,
         ROW_NUMBER() OVER (PARTITION BY cs.region ORDER BY AVG(id.value) DESC) AS rn
  FROM `bigquery-public-data.world_bank_wdi.country_summary` AS cs
  JOIN `bigquery-public-data.world_bank_wdi.indicators_data` AS id
    ON cs.country_code = id.country_code
  WHERE cs.income_group LIKE 'High income%' 
    AND id.indicator_code = 'SP.DYN.CBRT.IN' 
    AND id.year BETWEEN 1980 AND 1989
  GROUP BY cs.region, cs.short_name
) AS t
WHERE t.rn = 1;