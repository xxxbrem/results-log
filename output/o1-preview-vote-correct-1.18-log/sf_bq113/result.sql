WITH emp_2000 AS (
  SELECT
    "area_fips",
    AVG("month3_emplvl_23_construction") AS "avg_employment_2000"
  FROM (
    SELECT * FROM BLS.BLS_QCEW._2000_Q1
    UNION ALL
    SELECT * FROM BLS.BLS_QCEW._2000_Q2
    UNION ALL
    SELECT * FROM BLS.BLS_QCEW._2000_Q3
    UNION ALL
    SELECT * FROM BLS.BLS_QCEW._2000_Q4
  ) AS t
  WHERE "area_fips" LIKE '49%'
  GROUP BY "area_fips"
),
emp_2018 AS (
  SELECT
    "area_fips",
    AVG("month3_emplvl_23_construction") AS "avg_employment_2018"
  FROM (
    SELECT * FROM BLS.BLS_QCEW._2018_Q1
    UNION ALL
    SELECT * FROM BLS.BLS_QCEW._2018_Q2
    UNION ALL
    SELECT * FROM BLS.BLS_QCEW._2018_Q3
    UNION ALL
    SELECT * FROM BLS.BLS_QCEW._2018_Q4
  ) AS t
  WHERE "area_fips" LIKE '49%'
  GROUP BY "area_fips"
),
emp_growth AS (
  SELECT
    e2000."area_fips",
    e2000."avg_employment_2000",
    e2018."avg_employment_2018",
    ROUND(((e2018."avg_employment_2018" - e2000."avg_employment_2000") / e2000."avg_employment_2000") * 100, 4) AS "Percentage_increase"
  FROM emp_2000 e2000
  JOIN emp_2018 e2018 ON e2000."area_fips" = e2018."area_fips"
  WHERE e2000."avg_employment_2000" IS NOT NULL AND e2000."avg_employment_2000" > 0
),
county_names AS (
  SELECT DISTINCT
    "county_fips_code",
    "county_name"
  FROM BLS.GEO_US_BOUNDARIES.COUNTIES
  WHERE "state_fips_code" = '49'
)
SELECT
  cn."county_name" AS "County",
  eg."Percentage_increase"
FROM emp_growth eg
JOIN county_names cn ON cn."county_fips_code" = eg."area_fips"
ORDER BY eg."Percentage_increase" DESC NULLS LAST
LIMIT 1;