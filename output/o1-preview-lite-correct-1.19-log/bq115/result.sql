SELECT 
  a.country_code AS Country_Code, 
  a.country_name AS Country_Name, 
  ROUND((b.population_under_25 / a.midyear_population) * 100, 4) AS Percentage_Under_25
FROM 
  `bigquery-public-data.census_bureau_international.midyear_population` AS a
JOIN
  (
    SELECT 
      country_code, 
      SUM(population) AS population_under_25
    FROM 
      `bigquery-public-data.census_bureau_international.midyear_population_agespecific`
    WHERE 
      year = 2017 AND age < 25
    GROUP BY 
      country_code
  ) AS b
ON 
  a.country_code = b.country_code
WHERE 
  a.year = 2017
ORDER BY 
  Percentage_Under_25 DESC
LIMIT 1;