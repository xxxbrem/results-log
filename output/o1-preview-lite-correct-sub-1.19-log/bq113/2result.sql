WITH
  employment_2000 AS (
    SELECT geoid, month3_emplvl_23_construction AS construction_2000
    FROM `bigquery-public-data.bls_qcew.2000_q1`
    WHERE LEFT(geoid, 2) = '49' AND month3_emplvl_23_construction IS NOT NULL
  ),
  employment_2018 AS (
    SELECT geoid, month3_emplvl_23_construction AS construction_2018
    FROM `bigquery-public-data.bls_qcew.2018_q1`
    WHERE LEFT(geoid, 2) = '49' AND month3_emplvl_23_construction IS NOT NULL
  )
SELECT
  counties.county_name AS County,
  ROUND(((employment_2018.construction_2018 - employment_2000.construction_2000) / employment_2000.construction_2000) * 100, 4) AS Percentage_increase_construction_jobs
FROM
  employment_2000
JOIN
  employment_2018
ON employment_2000.geoid = employment_2018.geoid
JOIN
  `bigquery-public-data.geo_us_boundaries.counties` AS counties
ON employment_2000.geoid = counties.geo_id
WHERE
  employment_2000.construction_2000 > 0
  AND counties.state_fips_code = '49'
ORDER BY
  Percentage_increase_construction_jobs DESC
LIMIT 1;