WITH total_population_under_20 AS (
  SELECT 
    t1."country_code", 
    t1."country_name", 
    SUM(t1."population") AS total_population_under_20
  FROM 
    CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL.MIDYEAR_POPULATION_AGESPECIFIC t1
  WHERE 
    t1."year" = 2020 AND t1."age" < 20
  GROUP BY 
    t1."country_code", 
    t1."country_name"
),
total_midyear_population AS (
  SELECT 
    t2."country_code", 
    t2."country_name", 
    t2."midyear_population" AS total_midyear_population
  FROM 
    CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL.MIDYEAR_POPULATION t2
  WHERE 
    t2."year" = 2020
)
SELECT 
  tpu20."country_name",
  tpu20.total_population_under_20,
  tmp.total_midyear_population, 
  ROUND((tpu20.total_population_under_20 / NULLIF(tmp.total_midyear_population, 0)) * 100, 4) AS percentage_under_20
FROM 
  total_population_under_20 tpu20
JOIN 
  total_midyear_population tmp
ON 
  tpu20."country_code" = tmp."country_code" AND tpu20."country_name" = tmp."country_name"
WHERE
  tmp.total_midyear_population > 0
ORDER BY 
  percentage_under_20 DESC NULLS LAST
LIMIT 10;