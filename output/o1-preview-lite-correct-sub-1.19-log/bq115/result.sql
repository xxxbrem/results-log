SELECT country_name,
       ROUND((population_under_25 / midyear_population) * 100, 4) AS percentage_under_25
FROM (
  SELECT country_code, country_name, SUM(population) AS population_under_25
  FROM `bigquery-public-data.census_bureau_international.midyear_population_agespecific`
  WHERE year = 2017 AND age < 25
  GROUP BY country_code, country_name
) AS under_25
JOIN (
  SELECT country_code, midyear_population
  FROM `bigquery-public-data.census_bureau_international.midyear_population`
  WHERE year = 2017
) AS total_pop
USING (country_code)
ORDER BY percentage_under_25 DESC
LIMIT 1;