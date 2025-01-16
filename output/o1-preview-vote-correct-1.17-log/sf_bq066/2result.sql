WITH natality_data AS (
    SELECT
        SUBSTRING(n."Year",1,4) AS "Year",
        n."County_of_Residence_FIPS" AS county_fips,
        SUM(CASE WHEN n."Maternal_Morbidity_YN" = 0 THEN n."Births" ELSE 0 END) AS births_without_morbidity,
        SUM(n."Births") AS total_births
    FROM
        SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY n
    WHERE
        n."Year" IN ('2016-01-01', '2017-01-01', '2018-01-01')
    GROUP BY
        SUBSTRING(n."Year",1,4),
        n."County_of_Residence_FIPS"
),
census_data AS (
    SELECT
        '2016' AS "Year",
        c."geo_id" AS county_fips,
        (c."poverty" / NULLIF(c."pop_determined_poverty_status",0)) AS poverty_rate
    FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2015_5YR c
    UNION ALL
    SELECT
        '2017' AS "Year",
        c."geo_id" AS county_fips,
        (c."poverty" / NULLIF(c."pop_determined_poverty_status",0)) AS poverty_rate
    FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2016_5YR c
    UNION ALL
    SELECT
        '2018' AS "Year",
        c."geo_id" AS county_fips,
        (c."poverty" / NULLIF(c."pop_determined_poverty_status",0)) AS poverty_rate
    FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2017_5YR c
),
joined_data AS (
    SELECT
        n."Year",
        n.county_fips,
        n.births_without_morbidity,
        n.total_births,
        (n.births_without_morbidity / NULLIF(n.total_births,0)) AS percentage_without_morbidity,
        c.poverty_rate
    FROM
        natality_data n
    JOIN
        census_data c
    ON
        n.county_fips = c.county_fips
        AND n."Year" = c."Year"
    WHERE
        n.total_births > 0
        AND c.poverty_rate IS NOT NULL
),
correlations AS (
    SELECT
        "Year",
        CORR(
            CAST(poverty_rate AS DOUBLE PRECISION),
            CAST(percentage_without_morbidity AS DOUBLE PRECISION)
        ) AS Pearson_Correlation_Coefficient
    FROM
        joined_data
    GROUP BY
        "Year"
)
SELECT
    "Year",
    ROUND(Pearson_Correlation_Coefficient, 4) AS Pearson_Correlation_Coefficient
FROM
    correlations
ORDER BY
    "Year";