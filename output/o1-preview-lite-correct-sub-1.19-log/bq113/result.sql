WITH emp_2000 AS (
  SELECT `geoid`, AVG(`month3_emplvl_23_construction`) AS `avg_emplvl_2000`
  FROM (
    SELECT `geoid`, `month3_emplvl_23_construction` FROM `bigquery-public-data.bls_qcew.2000_q1`
    UNION ALL
    SELECT `geoid`, `month3_emplvl_23_construction` FROM `bigquery-public-data.bls_qcew.2000_q2`
    UNION ALL
    SELECT `geoid`, `month3_emplvl_23_construction` FROM `bigquery-public-data.bls_qcew.2000_q3`
    UNION ALL
    SELECT `geoid`, `month3_emplvl_23_construction` FROM `bigquery-public-data.bls_qcew.2000_q4`
  )
  WHERE `geoid` LIKE '49%' AND `month3_emplvl_23_construction` IS NOT NULL
  GROUP BY `geoid`
),
emp_2018 AS (
  SELECT `geoid`, AVG(`month3_emplvl_23_construction`) AS `avg_emplvl_2018`
  FROM (
    SELECT `geoid`, `month3_emplvl_23_construction` FROM `bigquery-public-data.bls_qcew.2018_q1`
    UNION ALL
    SELECT `geoid`, `month3_emplvl_23_construction` FROM `bigquery-public-data.bls_qcew.2018_q2`
    UNION ALL
    SELECT `geoid`, `month3_emplvl_23_construction` FROM `bigquery-public-data.bls_qcew.2018_q3`
    UNION ALL
    SELECT `geoid`, `month3_emplvl_23_construction` FROM `bigquery-public-data.bls_qcew.2018_q4`
  )
  WHERE `geoid` LIKE '49%' AND `month3_emplvl_23_construction` IS NOT NULL
  GROUP BY `geoid`
)
SELECT
  c.`county_name`,
  ROUND(((e2018.`avg_emplvl_2018` - e2000.`avg_emplvl_2000`) / e2000.`avg_emplvl_2000`) * 100, 4) AS `percentage_increase`
FROM emp_2000 e2000
JOIN emp_2018 e2018 ON e2000.`geoid` = e2018.`geoid`
JOIN `bigquery-public-data.geo_us_boundaries.counties` c ON e2000.`geoid` = c.`county_fips_code`
WHERE c.`state_fips_code` = '49' AND e2000.`avg_emplvl_2000` > 0
ORDER BY `percentage_increase` DESC
LIMIT 1