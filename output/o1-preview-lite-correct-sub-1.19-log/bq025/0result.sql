WITH pop_under_20 AS (
  SELECT
    country_code,
    country_name,
    SUM(population) AS Population_Under_20
  FROM
    `bigquery-public-data.census_bureau_international.midyear_population_agespecific`
  WHERE
    year = 2020 AND age < 20
  GROUP BY
    country_code,
    country_name
),
total_pop AS (
  SELECT
    country_code,
    midyear_population AS Total_Midyear_Population
  FROM
    `bigquery-public-data.census_bureau_international.midyear_population`
  WHERE
    year = 2020 AND midyear_population > 0
)
SELECT
  p.country_name AS Country,
  p.Population_Under_20,
  t.Total_Midyear_Population,
  ROUND((p.Population_Under_20 / t.Total_Midyear_Population) * 100, 4) AS Percentage_Under_20
FROM
  pop_under_20 p
JOIN
  total_pop t
ON
  p.country_code = t.country_code
ORDER BY
  Percentage_Under_20 DESC,
  Country ASC
LIMIT
  10;