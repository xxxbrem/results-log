SELECT
  t1.country_name,
  ROUND( (t1.population_under_25 / t2.midyear_population) * 100, 4 ) AS percentage_under_25
FROM
  (
    SELECT country_name, SUM(population) AS population_under_25
    FROM `bigquery-public-data.census_bureau_international.midyear_population_agespecific`
    WHERE year = 2017 AND age < 25
    GROUP BY country_name
  ) AS t1
JOIN
  (
    SELECT country_name, midyear_population
    FROM `bigquery-public-data.census_bureau_international.midyear_population`
    WHERE year = 2017
  ) AS t2
ON t1.country_name = t2.country_name
ORDER BY percentage_under_25 DESC
LIMIT 1;