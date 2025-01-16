WITH

-- 2016 Data
Natality_2016 AS (
    SELECT
        LPAD("County_of_Residence_FIPS", 5, '0') AS "County_FIPS",
        SUM(CASE WHEN "Maternal_Morbidity_YN" = 0 THEN "Births" ELSE 0 END) AS "births_no_morbidity",
        SUM("Births") AS "total_births"
    FROM
        SDOH.SDOH_CDC_WONDER_NATALITY."COUNTY_NATALITY_BY_MATERNAL_MORBIDITY"
    WHERE
        "Year" = '2016-01-01'
    GROUP BY
        LPAD("County_of_Residence_FIPS", 5, '0')
),
Poverty_2015 AS (
    SELECT
        SUBSTRING("geo_id", -5) AS "County_FIPS",
        "poverty" AS "poverty_rate"
    FROM
        SDOH.CENSUS_BUREAU_ACS."COUNTY_2015_5YR"
),
Combined_2016 AS (
    SELECT
        '2016' AS "Year",
        N."County_FIPS",
        P."poverty_rate",
        N."births_no_morbidity",
        N."total_births",
        (N."births_no_morbidity" / N."total_births") * 100 AS "percentage_no_morbidity"
    FROM
        Natality_2016 N
    JOIN
        Poverty_2015 P
        ON N."County_FIPS" = P."County_FIPS"
    WHERE
        N."total_births" > 0 AND P."poverty_rate" IS NOT NULL
),

-- 2017 Data
Natality_2017 AS (
    SELECT
        LPAD("County_of_Residence_FIPS", 5, '0') AS "County_FIPS",
        SUM(CASE WHEN "Maternal_Morbidity_YN" = 0 THEN "Births" ELSE 0 END) AS "births_no_morbidity",
        SUM("Births") AS "total_births"
    FROM
        SDOH.SDOH_CDC_WONDER_NATALITY."COUNTY_NATALITY_BY_MATERNAL_MORBIDITY"
    WHERE
        "Year" = '2017-01-01'
    GROUP BY
        LPAD("County_of_Residence_FIPS", 5, '0')
),
Poverty_2016 AS (
    SELECT
        SUBSTRING("geo_id", -5) AS "County_FIPS",
        "poverty" AS "poverty_rate"
    FROM
        SDOH.CENSUS_BUREAU_ACS."COUNTY_2016_5YR"
),
Combined_2017 AS (
    SELECT
        '2017' AS "Year",
        N."County_FIPS",
        P."poverty_rate",
        N."births_no_morbidity",
        N."total_births",
        (N."births_no_morbidity" / N."total_births") * 100 AS "percentage_no_morbidity"
    FROM
        Natality_2017 N
    JOIN
        Poverty_2016 P
        ON N."County_FIPS" = P."County_FIPS"
    WHERE
        N."total_births" > 0 AND P."poverty_rate" IS NOT NULL
),

-- 2018 Data
Natality_2018 AS (
    SELECT
        LPAD("County_of_Residence_FIPS", 5, '0') AS "County_FIPS",
        SUM(CASE WHEN "Maternal_Morbidity_YN" = 0 THEN "Births" ELSE 0 END) AS "births_no_morbidity",
        SUM("Births") AS "total_births"
    FROM
        SDOH.SDOH_CDC_WONDER_NATALITY."COUNTY_NATALITY_BY_MATERNAL_MORBIDITY"
    WHERE
        "Year" = '2018-01-01'
    GROUP BY
        LPAD("County_of_Residence_FIPS", 5, '0')
),
Poverty_2017 AS (
    SELECT
        SUBSTRING("geo_id", -5) AS "County_FIPS",
        "poverty" AS "poverty_rate"
    FROM
        SDOH.CENSUS_BUREAU_ACS."COUNTY_2017_5YR"
),
Combined_2018 AS (
    SELECT
        '2018' AS "Year",
        N."County_FIPS",
        P."poverty_rate",
        N."births_no_morbidity",
        N."total_births",
        (N."births_no_morbidity" / N."total_births") * 100 AS "percentage_no_morbidity"
    FROM
        Natality_2018 N
    JOIN
        Poverty_2017 P
        ON N."County_FIPS" = P."County_FIPS"
    WHERE
        N."total_births" > 0 AND P."poverty_rate" IS NOT NULL
),

All_Data AS (
    SELECT * FROM Combined_2016
    UNION ALL
    SELECT * FROM Combined_2017
    UNION ALL
    SELECT * FROM Combined_2018
)

SELECT
    "Year",
    ROUND(CORR("poverty_rate", "percentage_no_morbidity"), 4) AS "Pearson_Correlation_Coefficient"
FROM
    All_Data
GROUP BY
    "Year"
ORDER BY
    "Year";