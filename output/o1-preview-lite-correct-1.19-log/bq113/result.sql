WITH empl_2000 AS (
  SELECT geoid, 
         CAST(month3_emplvl_23_construction AS FLOAT64) AS emplvl_2000
  FROM `bigquery-public-data.bls_qcew.2000_q4`
  WHERE SUBSTR(geoid, 1, 2) = '49'
),
empl_2018 AS (
  SELECT geoid, 
         CAST(month3_emplvl_23_construction AS FLOAT64) AS emplvl_2018
  FROM `bigquery-public-data.bls_qcew.2018_q4`
  WHERE SUBSTR(geoid, 1, 2) = '49'
),
empl_change AS (
  SELECT e2018.geoid,
         e2018.emplvl_2018,
         e2000.emplvl_2000
  FROM empl_2018 e2018
  INNER JOIN empl_2000 e2000 USING (geoid)
),
county_names AS (
  SELECT geo_id, county_name
  FROM `bigquery-public-data.geo_us_boundaries.counties`
  WHERE state_fips_code = '49'
)
SELECT cn.county_name AS County_name,
       ROUND(((ec.emplvl_2018 - ec.emplvl_2000)/ec.emplvl_2000)*100, 4) AS Percentage_increase
FROM empl_change ec
JOIN county_names cn
  ON ec.geoid = cn.geo_id
WHERE ec.emplvl_2000 > 0
ORDER BY Percentage_increase DESC
LIMIT 1;