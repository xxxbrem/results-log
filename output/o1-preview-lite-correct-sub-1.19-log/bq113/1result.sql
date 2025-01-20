WITH
  utah_counties AS (
    SELECT
      county_name,
      county_fips_code AS area_fips
    FROM
      `bigquery-public-data.geo_us_boundaries.counties`
    WHERE
      state_fips_code = '49'
  ),
  employment_2000 AS (
    SELECT
      area_fips,
      AVG(month3_emplvl_23_construction) AS avg_emplvl_2000
    FROM (
      SELECT area_fips, month3_emplvl_23_construction FROM `bigquery-public-data.bls_qcew.2000_q1`
      UNION ALL
      SELECT area_fips, month3_emplvl_23_construction FROM `bigquery-public-data.bls_qcew.2000_q2`
      UNION ALL
      SELECT area_fips, month3_emplvl_23_construction FROM `bigquery-public-data.bls_qcew.2000_q3`
      UNION ALL
      SELECT area_fips, month3_emplvl_23_construction FROM `bigquery-public-data.bls_qcew.2000_q4`
    )
    WHERE area_fips LIKE '49%'
    GROUP BY area_fips
  ),
  employment_2018 AS (
    SELECT
      area_fips,
      AVG(month3_emplvl_23_construction) AS avg_emplvl_2018
    FROM (
      SELECT area_fips, month3_emplvl_23_construction FROM `bigquery-public-data.bls_qcew.2018_q1`
      UNION ALL
      SELECT area_fips, month3_emplvl_23_construction FROM `bigquery-public-data.bls_qcew.2018_q2`
      UNION ALL
      SELECT area_fips, month3_emplvl_23_construction FROM `bigquery-public-data.bls_qcew.2018_q3`
      UNION ALL
      SELECT area_fips, month3_emplvl_23_construction FROM `bigquery-public-data.bls_qcew.2018_q4`
    )
    WHERE area_fips LIKE '49%'
    GROUP BY area_fips
  ),
  percentage_changes AS (
    SELECT
      utah_counties.county_name,
      ((employment_2018.avg_emplvl_2018 - employment_2000.avg_emplvl_2000) / employment_2000.avg_emplvl_2000) * 100 AS percentage_increase
    FROM
      utah_counties
    JOIN
      employment_2000
    ON
      utah_counties.area_fips = employment_2000.area_fips
    JOIN
      employment_2018
    ON
      utah_counties.area_fips = employment_2018.area_fips
    WHERE
      employment_2000.avg_emplvl_2000 > 0
  )
SELECT
  county_name,
  ROUND(percentage_increase, 4) AS percentage_increase
FROM
  percentage_changes
ORDER BY
  percentage_increase DESC
LIMIT
  1;