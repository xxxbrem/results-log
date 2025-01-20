WITH gdp_data AS (
  SELECT
    cs.region AS Region,
    id.value AS gdp
  FROM `bigquery-public-data.world_bank_wdi.indicators_data` AS id
  JOIN `bigquery-public-data.world_bank_wdi.country_summary` AS cs
    ON id.country_code = cs.country_code
  WHERE id.indicator_code = 'NY.GDP.MKTP.KD'
    AND id.year = 2019
    AND id.value IS NOT NULL
    AND cs.region NOT IN ('Aggregates', 'World', '')
    AND cs.region IS NOT NULL
),
median_gdp_per_region AS (
  SELECT
    Region,
    IF(
      MOD(COUNT(*), 2) = 1,
      ARRAY_AGG(gdp ORDER BY gdp ASC)[OFFSET(DIV(COUNT(*), 2))],
      (
        ARRAY_AGG(gdp ORDER BY gdp ASC)[OFFSET(DIV(COUNT(*), 2) - 1)] +
        ARRAY_AGG(gdp ORDER BY gdp ASC)[OFFSET(DIV(COUNT(*), 2))]
      ) / 2
    ) AS median_gdp
  FROM gdp_data
  GROUP BY Region
)

SELECT
  Region,
  ROUND(median_gdp, 4) AS Median_GDP
FROM median_gdp_per_region
ORDER BY median_gdp DESC
LIMIT 1;