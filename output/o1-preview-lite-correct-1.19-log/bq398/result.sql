SELECT
  indicator_name,
  indicator_code,
  ROUND(MAX(value), 4) AS total_debt_value
FROM
  `bigquery-public-data.world_bank_wdi.indicators_data`
WHERE
  country_code = 'RUS'
  AND value IS NOT NULL
  AND indicator_code LIKE 'DT.%'
GROUP BY
  indicator_name,
  indicator_code
ORDER BY
  total_debt_value DESC
LIMIT 3;