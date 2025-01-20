SELECT `indicator_name`, `value`
FROM `bigquery-public-data`.`world_bank_wdi`.`indicators_data`
WHERE `country_name` = 'Russian Federation'
  AND `year` = 2020
  AND `value` IS NOT NULL
  AND `indicator_name` LIKE '%debt%'
ORDER BY `value` DESC, `indicator_name`
LIMIT 3;