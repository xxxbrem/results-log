WITH total_births AS (
    SELECT "Year", "County_of_Residence_FIPS", SUM("Births") AS total_births
    FROM SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY
    WHERE "Year" BETWEEN '2016-01-01' AND '2018-12-31'
    GROUP BY "Year", "County_of_Residence_FIPS"
),
births_without_morbidity AS (
    SELECT "Year", "County_of_Residence_FIPS", SUM("Births") AS births_without_morbidity
    FROM SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
    WHERE "Maternal_Morbidity_YN" = 0 AND "Year" BETWEEN '2016-01-01' AND '2018-12-31'
    GROUP BY "Year", "County_of_Residence_FIPS"
),
percentages AS (
    SELECT tb."Year", tb."County_of_Residence_FIPS",
           (bwm.births_without_morbidity / tb.total_births) * 100.0 AS percent_without_morbidity
    FROM total_births tb
    JOIN births_without_morbidity bwm
      ON tb."Year" = bwm."Year" AND tb."County_of_Residence_FIPS" = bwm."County_of_Residence_FIPS"
),
poverty_data AS (
    SELECT '2016' AS "Year", "geo_id" AS "County_of_Residence_FIPS", "poverty"
    FROM SDOH.CENSUS_BUREAU_ACS.COUNTY_2015_5YR
    UNION ALL
    SELECT '2017' AS "Year", "geo_id" AS "County_of_Residence_FIPS", "poverty"
    FROM SDOH.CENSUS_BUREAU_ACS.COUNTY_2016_5YR
    UNION ALL
    SELECT '2018' AS "Year", "geo_id" AS "County_of_Residence_FIPS", "poverty"
    FROM SDOH.CENSUS_BUREAU_ACS.COUNTY_2017_5YR
),
combined_data AS (
    SELECT CAST(p."Year" AS VARCHAR) AS "Year",
           p."County_of_Residence_FIPS",
           p.percent_without_morbidity,
           pd."poverty"
    FROM percentages p
    JOIN poverty_data pd
      ON TO_CHAR(p."Year", 'YYYY') = pd."Year" AND p."County_of_Residence_FIPS" = pd."County_of_Residence_FIPS"
)
SELECT "Year", ROUND(CORR("poverty", percent_without_morbidity), 4) AS Pearson_Correlation_Coefficient
FROM combined_data
GROUP BY "Year"
ORDER BY "Year";