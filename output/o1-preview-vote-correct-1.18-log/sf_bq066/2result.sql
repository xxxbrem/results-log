WITH total_births AS (
    SELECT
        "County_of_Residence_FIPS" AS county_fips,
        EXTRACT(year FROM "Year") AS year,
        SUM("Births") AS total_births
    FROM "SDOH"."SDOH_CDC_WONDER_NATALITY"."COUNTY_NATALITY"
    WHERE EXTRACT(year FROM "Year") BETWEEN 2016 AND 2018
    GROUP BY
        "County_of_Residence_FIPS",
        EXTRACT(year FROM "Year")
),
births_without_morbidity AS (
    SELECT
        "County_of_Residence_FIPS" AS county_fips,
        EXTRACT(year FROM "Year") AS year,
        SUM("Births") AS births_without_morbidity
    FROM "SDOH"."SDOH_CDC_WONDER_NATALITY"."COUNTY_NATALITY_BY_MATERNAL_MORBIDITY"
    WHERE "Maternal_Morbidity_YN" = 0
      AND EXTRACT(year FROM "Year") BETWEEN 2016 AND 2018
    GROUP BY
        "County_of_Residence_FIPS",
        EXTRACT(year FROM "Year")
),
births_data AS (
    SELECT
        t.county_fips,
        t.year,
        t.total_births,
        b.births_without_morbidity,
        (b.births_without_morbidity / NULLIF(t.total_births,0) * 100) AS pct_without_morbidity
    FROM total_births t
    JOIN births_without_morbidity b
        ON t.county_fips = b.county_fips
        AND t.year = b.year
),
poverty_data AS (
    SELECT
        "geo_id" AS county_fips,
        2016 AS year,
        (("poverty" / NULLIF("total_pop", 0)) * 100) AS poverty_rate
    FROM "SDOH"."CENSUS_BUREAU_ACS"."COUNTY_2015_5YR"
    WHERE "poverty" IS NOT NULL AND "total_pop" IS NOT NULL
    UNION ALL
    SELECT
        "geo_id" AS county_fips,
        2017 AS year,
        (("poverty" / NULLIF("total_pop", 0)) * 100) AS poverty_rate
    FROM "SDOH"."CENSUS_BUREAU_ACS"."COUNTY_2016_5YR"
    WHERE "poverty" IS NOT NULL AND "total_pop" IS NOT NULL
    UNION ALL
    SELECT
        "geo_id" AS county_fips,
        2018 AS year,
        (("poverty" / NULLIF("total_pop", 0)) * 100) AS poverty_rate
    FROM "SDOH"."CENSUS_BUREAU_ACS"."COUNTY_2017_5YR"
    WHERE "poverty" IS NOT NULL AND "total_pop" IS NOT NULL
),
combined_data AS (
    SELECT
        b.county_fips,
        b.year,
        b.pct_without_morbidity,
        p.poverty_rate
    FROM births_data b
    JOIN poverty_data p
        ON b.county_fips = p.county_fips
        AND b.year = p.year
    WHERE p.poverty_rate IS NOT NULL
      AND b.pct_without_morbidity IS NOT NULL
)
SELECT
    year,
    ROUND(CORR(poverty_rate, pct_without_morbidity), 4) AS Pearson_Correlation
FROM combined_data
GROUP BY year
ORDER BY year;