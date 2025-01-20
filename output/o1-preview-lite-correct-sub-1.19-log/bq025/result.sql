WITH population_under_20 AS (
  SELECT country_code, country_name, SUM(population) AS Population_Under_20
  FROM `bigquery-public-data.census_bureau_international.midyear_population_agespecific`
  WHERE year = 2020 AND age < 20
  GROUP BY country_code, country_name
),
total_population AS (
  SELECT country_code, midyear_population AS Total_Midyear_Population
  FROM `bigquery-public-data.census_bureau_international.midyear_population`
  WHERE year = 2020
)
SELECT 
  pu.country_name AS Country,
  pu.Population_Under_20,
  tp.Total_Midyear_Population,
  ROUND(pu.Population_Under_20 * 100.0 / tp.Total_Midyear_Population, 4) AS Percentage_Under_20
FROM population_under_20 pu
JOIN total_population tp USING (country_code)
ORDER BY Percentage_Under_20 DESC, pu.Population_Under_20 DESC
LIMIT 10;