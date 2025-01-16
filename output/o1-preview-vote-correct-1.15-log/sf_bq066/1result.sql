WITH
  NatalityData AS (
    SELECT
      EXTRACT(year FROM "Year") AS "year",
      LPAD("County_of_Residence_FIPS", 5, '0') AS county_fips,
      SUM(CASE WHEN "Maternal_Morbidity_YN" = 0 THEN "Births" ELSE 0 END) AS births_no_morbidity,
      SUM("Births") AS total_births
    FROM
      SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
    WHERE
      "Year" IN ('2016-01-01', '2017-01-01', '2018-01-01')
    GROUP BY
      EXTRACT(year FROM "Year"),
      LPAD("County_of_Residence_FIPS", 5, '0')
  ),
  PovertyData AS (
    SELECT
      2016 AS "year",
      "geo_id" AS county_fips,
      "poverty" AS poverty_rate
    FROM
      SDOH.CENSUS_BUREAU_ACS.COUNTY_2015_5YR
    WHERE
      "poverty" IS NOT NULL

    UNION ALL

    SELECT
      2017 AS "year",
      "geo_id" AS county_fips,
      "poverty" AS poverty_rate
    FROM
      SDOH.CENSUS_BUREAU_ACS.COUNTY_2016_5YR
    WHERE
      "poverty" IS NOT NULL

    UNION ALL

    SELECT
      2018 AS "year",
      "geo_id" AS county_fips,
      "poverty" AS poverty_rate
    FROM
      SDOH.CENSUS_BUREAU_ACS.COUNTY_2017_5YR
    WHERE
      "poverty" IS NOT NULL
  )

SELECT
  n."year",
  ROUND(CORR(pov.poverty_rate, n.percentage_no_morbidity), 4) AS "Pearson_correlation_coefficient"
FROM
  (
    SELECT
      "year",
      county_fips,
      births_no_morbidity,
      total_births,
      100.0 * births_no_morbidity / total_births AS percentage_no_morbidity
    FROM
      NatalityData
    WHERE
      total_births > 0
  ) n
INNER JOIN
  PovertyData pov
ON
  n."year" = pov."year" AND n.county_fips = pov.county_fips
GROUP BY
  n."year"
ORDER BY
  n."year";