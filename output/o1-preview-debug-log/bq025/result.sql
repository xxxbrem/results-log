SELECT 
    a.country_name,
    SUM(a.population) AS total_population_under_20,
    b.midyear_population AS total_midyear_population,
    ROUND((SUM(a.population) / b.midyear_population) * 100, 4) AS percentage_under_20
FROM `bigquery-public-data.census_bureau_international.midyear_population_agespecific` AS a
JOIN `bigquery-public-data.census_bureau_international.midyear_population` AS b
ON a.country_code = b.country_code AND a.year = b.year
WHERE a.year = 2020 AND a.age < 20
GROUP BY a.country_name, b.midyear_population
ORDER BY percentage_under_20 DESC
LIMIT 10;