WITH income_2015 AS (
  SELECT
    REGEXP_SUBSTR(a."geo_id", '\\d{5}$') AS "zip_code",
    a."median_income" AS "median_income_2015"
  FROM "CENSUS_BUREAU_ACS_2"."CENSUS_BUREAU_ACS"."ZIP_CODES_2015_5YR" AS a
  WHERE a."median_income" IS NOT NULL
),
income_2018 AS (
  SELECT
    REGEXP_SUBSTR(a."geo_id", '\\d{5}$') AS "zip_code",
    a."median_income" AS "median_income_2018"
  FROM "CENSUS_BUREAU_ACS_2"."CENSUS_BUREAU_ACS"."ZIP_CODES_2018_5YR" AS a
  WHERE a."median_income" IS NOT NULL
),
income_change_zip AS (
  SELECT
    i2015."zip_code",
    (i2018."median_income_2018" - i2015."median_income_2015") AS "income_change"
  FROM income_2015 AS i2015
  JOIN income_2018 AS i2018
    ON i2015."zip_code" = i2018."zip_code"
  WHERE i2015."zip_code" IS NOT NULL
    AND i2018."zip_code" IS NOT NULL
),
zip_to_state AS (
  SELECT
    zc."zip_code",
    zc."state_name"
  FROM "CENSUS_BUREAU_ACS_2"."GEO_US_BOUNDARIES"."ZIP_CODES" AS zc
  WHERE zc."zip_code" IS NOT NULL
),
income_change_state AS (
  SELECT
    zs."state_name",
    AVG(ic."income_change") AS "median_income_change"
  FROM income_change_zip AS ic
  JOIN zip_to_state AS zs
    ON ic."zip_code" = zs."zip_code"
  GROUP BY zs."state_name"
),
vulnerable_population AS (
  SELECT s."state_name",
    (
      (COALESCE(a."employed_wholesale_trade", 0) * 0.3842) +
      (
        (COALESCE(a."employed_agriculture_forestry_fishing_hunting_mining", 0) + COALESCE(a."employed_construction", 0))
        * 0.4807
      ) +
      (COALESCE(a."employed_arts_entertainment_recreation_accommodation_food", 0) * 0.8946) +
      (COALESCE(a."employed_information", 0) * 0.3132) +
      (COALESCE(a."employed_retail_trade", 0) * 0.51) +
      (COALESCE(a."employed_public_administration", 0) * 0.0393) +
      (COALESCE(a."employed_other_services_not_public_admin", 0) * 0.3656) +
      (COALESCE(a."employed_education_health_social", 0) * 0.2032) +
      (COALESCE(a."employed_transportation_warehousing_utilities", 0) * 0.3681) +
      (COALESCE(a."employed_manufacturing", 0) * 0.4062)
    ) AS "vulnerable_population"
  FROM "CENSUS_BUREAU_ACS_2"."CENSUS_BUREAU_ACS"."STATE_2017_5YR" AS a
  JOIN "CENSUS_BUREAU_ACS_2"."GEO_US_BOUNDARIES"."STATES" AS s
    ON a."geo_id" = s."geo_id"
)
SELECT vp."state_name" AS "State",
       ROUND(vp."vulnerable_population", 4) AS "Vulnerable_Population",
       ROUND(ic."median_income_change", 4) AS "Median_Income_Change"
FROM vulnerable_population vp
JOIN income_change_state ic
  ON vp."state_name" = ic."state_name"
ORDER BY vp."vulnerable_population" DESC NULLS LAST
LIMIT 10;