SELECT
  age_data.country_name,
  ROUND(SUM(age_data.population) / total_pop.midyear_population * 100, 4) AS percentage_under_25
FROM `bigquery-public-data.census_bureau_international.midyear_population_agespecific` AS age_data
JOIN `bigquery-public-data.census_bureau_international.midyear_population` AS total_pop
ON age_data.country_code = total_pop.country_code
  AND age_data.year = total_pop.year
WHERE age_data.year = 2017
  AND age_data.age < 25
GROUP BY age_data.country_name, total_pop.midyear_population
ORDER BY percentage_under_25 DESC
LIMIT 1;