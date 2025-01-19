SELECT
  c.region AS Region,
  ROUND(APPROX_QUANTILES(i.value, 2)[OFFSET(1)], 4) AS Median_GDP
FROM
  `bigquery-public-data.world_bank_wdi.indicators_data` AS i
JOIN
  `bigquery-public-data.world_bank_wdi.country_summary` AS c
ON
  i.country_code = c.country_code
WHERE
  i.indicator_code = 'NY.GDP.MKTP.KD'
  AND i.year = 2019
  AND c.region IS NOT NULL
  AND c.region != ''
  AND LENGTH(c.country_code) = 3
  -- Exclude aggregate entities like 'WLD' (World) by ensuring country codes have 3 letters
GROUP BY
  c.region
ORDER BY
  Median_GDP DESC
LIMIT 1;