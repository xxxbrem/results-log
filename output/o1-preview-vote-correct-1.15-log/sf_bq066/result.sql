WITH total_births AS (
    SELECT 
        "Year",
        LPAD(TRIM("County_of_Residence_FIPS"), 5, '0') AS County_FIPS,
        SUM("Births") AS total_births
    FROM SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY
    WHERE
        "Year" IN ('2016-01-01', '2017-01-01', '2018-01-01')
        AND "County_of_Residence_FIPS" NOT IN ('00000', '99999')
        AND "County_of_Residence_FIPS" IS NOT NULL
    GROUP BY "Year", LPAD(TRIM("County_of_Residence_FIPS"), 5, '0')
),
no_morbid_births AS (
    SELECT
        "Year",
        LPAD(TRIM("County_of_Residence_FIPS"), 5, '0') AS County_FIPS,
        SUM("Births") AS no_morbidity_births
    FROM SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
    WHERE
        "Year" IN ('2016-01-01', '2017-01-01', '2018-01-01')
        AND "Maternal_Morbidity_YN" = 0
        AND "County_of_Residence_FIPS" NOT IN ('00000', '99999')
        AND "County_of_Residence_FIPS" IS NOT NULL
    GROUP BY "Year", LPAD(TRIM("County_of_Residence_FIPS"), 5, '0')
),
natality AS (
    SELECT
        tb."Year",
        tb.County_FIPS,
        tb.total_births,
        nmb.no_morbidity_births,
        (nmb.no_morbidity_births * 100.0) / tb.total_births AS no_morbidity_percentage
    FROM total_births tb
    JOIN no_morbid_births nmb ON tb."Year" = nmb."Year" AND tb.County_FIPS = nmb.County_FIPS
    WHERE tb.total_births > 0
),
poverty_2015 AS (
    SELECT
        '2016-01-01' AS "Year",
        LPAD(TRIM("geo_id"), 5, '0') AS County_FIPS,
        ("poverty" / NULLIF("pop_determined_poverty_status", 0)) * 100 AS poverty_rate
    FROM SDOH.CENSUS_BUREAU_ACS.COUNTY_2015_5YR
    WHERE "geo_id" IS NOT NULL AND "poverty" IS NOT NULL AND "pop_determined_poverty_status" > 0
),
poverty_2016 AS (
    SELECT
        '2017-01-01' AS "Year",
        LPAD(TRIM("geo_id"), 5, '0') AS County_FIPS,
        ("poverty" / NULLIF("pop_determined_poverty_status", 0)) * 100 AS poverty_rate
    FROM SDOH.CENSUS_BUREAU_ACS.COUNTY_2016_5YR
    WHERE "geo_id" IS NOT NULL AND "poverty" IS NOT NULL AND "pop_determined_poverty_status" > 0
),
poverty_2017 AS (
    SELECT
        '2018-01-01' AS "Year",
        LPAD(TRIM("geo_id"), 5, '0') AS County_FIPS,
        ("poverty" / NULLIF("pop_determined_poverty_status", 0)) * 100 AS poverty_rate
    FROM SDOH.CENSUS_BUREAU_ACS.COUNTY_2017_5YR
    WHERE "geo_id" IS NOT NULL AND "poverty" IS NOT NULL AND "pop_determined_poverty_status" > 0
),
poverty AS (
    SELECT * FROM poverty_2015
    UNION ALL
    SELECT * FROM poverty_2016
    UNION ALL
    SELECT * FROM poverty_2017
),
joined_data AS (
    SELECT
        n."Year",
        n.County_FIPS,
        n.no_morbidity_percentage,
        p.poverty_rate
    FROM natality n
    JOIN poverty p ON n."Year" = p."Year" AND n.County_FIPS = p.County_FIPS
    WHERE p.poverty_rate IS NOT NULL AND n.no_morbidity_percentage IS NOT NULL
)
SELECT
    TO_CHAR(TO_DATE("Year"), 'YYYY') AS "Year",
    ROUND(CORR(poverty_rate, no_morbidity_percentage), 4) AS Pearson_Correlation
FROM joined_data
GROUP BY "Year"
ORDER BY "Year";