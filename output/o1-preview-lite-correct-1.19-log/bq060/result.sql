SELECT a.`country_name`, a.`net_migration`
FROM `bigquery-public-data.census_bureau_international.birth_death_growth_rates` AS a
JOIN `bigquery-public-data.census_bureau_international.country_names_area` AS b
ON a.`country_code` = b.`country_code`
WHERE a.`year` = 2017 AND b.`country_area` > 500
ORDER BY a.`net_migration` DESC
LIMIT 3;