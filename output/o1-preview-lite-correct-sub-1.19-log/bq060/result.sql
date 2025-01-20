SELECT area.`country_name`, ROUND(rates.`net_migration`, 4) AS Net_migration_rate
FROM `bigquery-public-data.census_bureau_international.country_names_area` AS area
JOIN `bigquery-public-data.census_bureau_international.birth_death_growth_rates` AS rates
ON area.`country_code` = rates.`country_code`
WHERE area.`country_area` > 500
  AND rates.`year` = 2017
ORDER BY rates.`net_migration` DESC, area.`country_name` ASC
LIMIT 3;