WITH per_year_data AS (
    SELECT
        '2016' AS "Year",
        RIGHT(P."geo_id", 5) AS "County_FIPS",
        (P."poverty" / NULLIF(P."pop_determined_poverty_status", 0)) AS "poverty_rate",
        (B."births_without_morbidity" / NULLIF(T."total_births", 0)) AS "percentage_without_morbidity"
    FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2015_5YR P
        INNER JOIN (
            SELECT
                "County_of_Residence_FIPS" AS "County_FIPS",
                SUM("Births") AS "births_without_morbidity"
            FROM
                SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
            WHERE
                "Year" = '2016-01-01' AND "Maternal_Morbidity_YN" = 0
            GROUP BY
                "County_of_Residence_FIPS"
        ) B ON RIGHT(P."geo_id", 5) = B."County_FIPS"
        INNER JOIN (
            SELECT
                "County_of_Residence_FIPS" AS "County_FIPS",
                SUM("Births") AS "total_births"
            FROM
                SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY
            WHERE
                "Year" = '2016-01-01'
            GROUP BY
                "County_of_Residence_FIPS"
        ) T ON B."County_FIPS" = T."County_FIPS"

    UNION ALL

    SELECT
        '2017' AS "Year",
        RIGHT(P."geo_id", 5) AS "County_FIPS",
        (P."poverty" / NULLIF(P."pop_determined_poverty_status", 0)) AS "poverty_rate",
        (B."births_without_morbidity" / NULLIF(T."total_births", 0)) AS "percentage_without_morbidity"
    FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2016_5YR P
        INNER JOIN (
            SELECT
                "County_of_Residence_FIPS" AS "County_FIPS",
                SUM("Births") AS "births_without_morbidity"
            FROM
                SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
            WHERE
                "Year" = '2017-01-01' AND "Maternal_Morbidity_YN" = 0
            GROUP BY
                "County_of_Residence_FIPS"
        ) B ON RIGHT(P."geo_id", 5) = B."County_FIPS"
        INNER JOIN (
            SELECT
                "County_of_Residence_FIPS" AS "County_FIPS",
                SUM("Births") AS "total_births"
            FROM
                SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY
            WHERE
                "Year" = '2017-01-01'
            GROUP BY
                "County_of_Residence_FIPS"
        ) T ON B."County_FIPS" = T."County_FIPS"

    UNION ALL

    SELECT
        '2018' AS "Year",
        RIGHT(P."geo_id", 5) AS "County_FIPS",
        (P."poverty" / NULLIF(P."pop_determined_poverty_status", 0)) AS "poverty_rate",
        (B."births_without_morbidity" / NULLIF(T."total_births", 0)) AS "percentage_without_morbidity"
    FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2017_5YR P
        INNER JOIN (
            SELECT
                "County_of_Residence_FIPS" AS "County_FIPS",
                SUM("Births") AS "births_without_morbidity"
            FROM
                SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
            WHERE
                "Year" = '2018-01-01' AND "Maternal_Morbidity_YN" = 0
            GROUP BY
                "County_of_Residence_FIPS"
        ) B ON RIGHT(P."geo_id", 5) = B."County_FIPS"
        INNER JOIN (
            SELECT
                "County_of_Residence_FIPS" AS "County_FIPS",
                SUM("Births") AS "total_births"
            FROM
                SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY
            WHERE
                "Year" = '2018-01-01'
            GROUP BY
                "County_of_Residence_FIPS"
        ) T ON B."County_FIPS" = T."County_FIPS"
)

SELECT
    "Year",
    ROUND(CORR("poverty_rate", "percentage_without_morbidity"), 4) AS "Pearson_Correlation_Coefficient"
FROM
    per_year_data
GROUP BY
    "Year"
ORDER BY
    "Year";