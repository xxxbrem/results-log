SELECT b.country_name AS Country_name, ROUND(b.net_migration, 4) AS Net_migration_rate
FROM `bigquery-public-data.census_bureau_international.birth_death_growth_rates` b
JOIN `bigquery-public-data.census_bureau_international.country_names_area` c
ON b.country_code = c.country_code
WHERE b.year = 2017 AND c.country_area > 500
ORDER BY b.net_migration DESC
LIMIT 3