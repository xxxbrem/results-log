WITH data_2016 AS (
  SELECT
    '2016' AS "Year",
    t."FIPS",
    p."poverty" AS "poverty_rate",
    (bwm."births_without_morbidity" * 1.0) / t."total_births" * 100 AS "percentage_no_morbidity"
  FROM
    (SELECT "County_of_Residence_FIPS" AS "FIPS", SUM("Births") AS "total_births"
     FROM SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY
     WHERE "Year" = '2016-01-01'
     GROUP BY "County_of_Residence_FIPS") t
    JOIN
    (SELECT "County_of_Residence_FIPS" AS "FIPS", SUM("Births") AS "births_without_morbidity"
     FROM SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
     WHERE "Year" = '2016-01-01' AND "Maternal_Morbidity_YN" = 0
     GROUP BY "County_of_Residence_FIPS") bwm
    ON t."FIPS" = bwm."FIPS"
    JOIN
    (SELECT RIGHT("geo_id", 5) AS "FIPS", "poverty"
     FROM SDOH.CENSUS_BUREAU_ACS.COUNTY_2015_5YR) p
    ON t."FIPS" = p."FIPS"
  WHERE t."total_births" > 0
),
data_2017 AS (
  SELECT
    '2017' AS "Year",
    t."FIPS",
    p."poverty" AS "poverty_rate",
    (bwm."births_without_morbidity" * 1.0) / t."total_births" * 100 AS "percentage_no_morbidity"
  FROM
    (SELECT "County_of_Residence_FIPS" AS "FIPS", SUM("Births") AS "total_births"
     FROM SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY
     WHERE "Year" = '2017-01-01'
     GROUP BY "County_of_Residence_FIPS") t
    JOIN
    (SELECT "County_of_Residence_FIPS" AS "FIPS", SUM("Births") AS "births_without_morbidity"
     FROM SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
     WHERE "Year" = '2017-01-01' AND "Maternal_Morbidity_YN" = 0
     GROUP BY "County_of_Residence_FIPS") bwm
    ON t."FIPS" = bwm."FIPS"
    JOIN
    (SELECT RIGHT("geo_id", 5) AS "FIPS", "poverty"
     FROM SDOH.CENSUS_BUREAU_ACS.COUNTY_2016_5YR) p
    ON t."FIPS" = p."FIPS"
  WHERE t."total_births" > 0
),
data_2018 AS (
  SELECT
    '2018' AS "Year",
    t."FIPS",
    p."poverty" AS "poverty_rate",
    (bwm."births_without_morbidity" * 1.0) / t."total_births" * 100 AS "percentage_no_morbidity"
  FROM
    (SELECT "County_of_Residence_FIPS" AS "FIPS", SUM("Births") AS "total_births"
     FROM SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY
     WHERE "Year" = '2018-01-01'
     GROUP BY "County_of_Residence_FIPS") t
    JOIN
    (SELECT "County_of_Residence_FIPS" AS "FIPS", SUM("Births") AS "births_without_morbidity"
     FROM SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
     WHERE "Year" = '2018-01-01' AND "Maternal_Morbidity_YN" = 0
     GROUP BY "County_of_Residence_FIPS") bwm
    ON t."FIPS" = bwm."FIPS"
    JOIN
    (SELECT RIGHT("geo_id", 5) AS "FIPS", "poverty"
     FROM SDOH.CENSUS_BUREAU_ACS.COUNTY_2017_5YR) p
    ON t."FIPS" = p."FIPS"
  WHERE t."total_births" > 0
),
combined_data AS (
  SELECT * FROM data_2016
  UNION ALL
  SELECT * FROM data_2017
  UNION ALL
  SELECT * FROM data_2018
)
SELECT
  "Year",
  ROUND(CORR("poverty_rate", "percentage_no_morbidity"), 4) AS "Pearson_Correlation_Coefficient"
FROM combined_data
GROUP BY "Year"
ORDER BY "Year";