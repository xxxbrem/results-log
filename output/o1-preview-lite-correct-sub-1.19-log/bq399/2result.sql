SELECT Region, Country, ROUND(Average_Crude_Birth_Rate, 4) AS Average_Crude_Birth_Rate
FROM (
  SELECT cs.region AS Region,
         cs.short_name AS Country,
         AVG(ind.value) AS Average_Crude_Birth_Rate,
         ROW_NUMBER() OVER (PARTITION BY cs.region ORDER BY AVG(ind.value) DESC) AS rn
  FROM `bigquery-public-data.world_bank_wdi.indicators_data` AS ind
  JOIN `bigquery-public-data.world_bank_wdi.country_summary` AS cs
    ON ind.country_code = cs.country_code
  WHERE ind.indicator_code = 'SP.DYN.CBRT.IN'
    AND ind.year BETWEEN 1980 AND 1989
    AND cs.income_group = 'High income'
  GROUP BY cs.region, cs.short_name
)
WHERE rn = 1
ORDER BY Region;