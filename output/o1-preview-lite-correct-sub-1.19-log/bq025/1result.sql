SELECT
  t1.country_name,
  t1.total_population_under_20,
  t2.midyear_population AS total_midyear_population,
  ROUND((t1.total_population_under_20 / t2.midyear_population) * 100, 4) AS percentage_under_20
FROM
  (
    SELECT
      country_code,
      country_name,
      SUM(population) AS total_population_under_20
    FROM
      `bigquery-public-data.census_bureau_international.midyear_population_agespecific`
    WHERE
      year = 2020 AND age < 20
    GROUP BY
      country_code,
      country_name
  ) t1
JOIN
  (
    SELECT
      country_code,
      midyear_population
    FROM
      `bigquery-public-data.census_bureau_international.midyear_population`
    WHERE
      year = 2020
  ) t2
ON
  t1.country_code = t2.country_code
ORDER BY
  percentage_under_20 DESC
LIMIT 10