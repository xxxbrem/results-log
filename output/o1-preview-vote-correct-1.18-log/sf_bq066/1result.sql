WITH natality AS (
    SELECT
        YEAR("Year") AS "Year",
        "County_of_Residence_FIPS" AS "CountyFIPS",
        SUM(CASE WHEN "Maternal_Morbidity_YN" = 0 THEN "Births" ELSE 0 END) AS "Births_No_MM",
        SUM("Births") AS "Total_Births"
    FROM
        SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
    WHERE
        "Year" IN ('2016-01-01', '2017-01-01', '2018-01-01')
    GROUP BY
        YEAR("Year"), "County_of_Residence_FIPS"
),
poverty AS (
    SELECT
        2016 AS "Year",
        "geo_id" AS "CountyFIPS",
        ("poverty" / "pop_determined_poverty_status") * 100 AS "poverty_rate"
    FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2015_5YR
    WHERE
        "pop_determined_poverty_status" > 0 AND "poverty" IS NOT NULL
    UNION ALL
    SELECT
        2017 AS "Year",
        "geo_id" AS "CountyFIPS",
        ("poverty" / "pop_determined_poverty_status") * 100 AS "poverty_rate"
    FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2016_5YR
    WHERE
        "pop_determined_poverty_status" > 0 AND "poverty" IS NOT NULL
    UNION ALL
    SELECT
        2018 AS "Year",
        "geo_id" AS "CountyFIPS",
        ("poverty" / "pop_determined_poverty_status") * 100 AS "poverty_rate"
    FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2017_5YR
    WHERE
        "pop_determined_poverty_status" > 0 AND "poverty" IS NOT NULL
),
combined AS (
    SELECT
        n."Year",
        n."CountyFIPS",
        n."Births_No_MM",
        n."Total_Births",
        (n."Births_No_MM" / NULLIF(n."Total_Births", 0)) * 100 AS "percentage_no_maternal_morbidity",
        p."poverty_rate"
    FROM
        natality n
    JOIN
        poverty p
    ON
        n."Year" = p."Year" AND n."CountyFIPS" = p."CountyFIPS"
    WHERE
        n."Total_Births" > 0 AND p."poverty_rate" IS NOT NULL
)
SELECT
    "Year",
    ROUND(CORR("poverty_rate", "percentage_no_maternal_morbidity"), 4) AS "PearsonCorrelationCoefficient"
FROM
    combined
GROUP BY
    "Year"
ORDER BY
    "Year";