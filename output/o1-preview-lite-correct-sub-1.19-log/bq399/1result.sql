WITH high_income_countries AS (
  SELECT `country_code`, `short_name` AS `country`, `region`
  FROM `bigquery-public-data.world_bank_wdi.country_summary`
  WHERE `income_group` LIKE 'High income%'
),
birth_rate_80s AS (
  SELECT `country_code`, `year`, `value`
  FROM `bigquery-public-data.world_bank_wdi.indicators_data`
  WHERE `indicator_code` = 'SP.DYN.CBRT.IN'
    AND `year` BETWEEN 1980 AND 1989
),
avg_birth_rate AS (
  SELECT `country_code`, AVG(`value`) AS `avg_crude_birth_rate`
  FROM birth_rate_80s
  GROUP BY `country_code`
),
high_income_birth_rate AS (
  SELECT hi.`country_code`, hi.`country`, hi.`region`, ab.`avg_crude_birth_rate`
  FROM high_income_countries hi
  JOIN avg_birth_rate ab
    ON hi.`country_code` = ab.`country_code`
),
ranked_birth_rate AS (
  SELECT hib.`region`, hib.`country_code`, hib.`country`, hib.`avg_crude_birth_rate`,
         ROW_NUMBER() OVER (PARTITION BY hib.`region` ORDER BY hib.`avg_crude_birth_rate` DESC) AS `rn`
  FROM high_income_birth_rate hib
)
SELECT `country`, `region`, ROUND(`avg_crude_birth_rate`,4) AS `Average_Crude_Birth_Rate`
FROM ranked_birth_rate
WHERE `rn` = 1