WITH natality_data AS (
    SELECT
        "Year",
        LPAD("County_of_Residence_FIPS", 5, '0') AS County_FIPS,
        SUM(CASE WHEN "Maternal_Morbidity_YN" = 0 THEN "Births" ELSE 0 END)::FLOAT / SUM("Births")::FLOAT * 100 AS Percent_Births_Without_Morbidity
    FROM
        SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY_BY_MATERNAL_MORBIDITY
    WHERE
        "Year" BETWEEN '2016-01-01' AND '2018-12-31' AND "Maternal_Morbidity_YN" IN (0, 1)
    GROUP BY
        "Year",
        "County_of_Residence_FIPS"
),
poverty_data AS (
    SELECT
        '2016-01-01' AS Year,
        LPAD("geo_id", 5, '0') AS County_FIPS,
        ("poverty" / "pop_determined_poverty_status") * 100 AS poverty_rate
    FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2015_5YR
    WHERE
        "pop_determined_poverty_status" > 0
    UNION ALL
    SELECT
        '2017-01-01' AS Year,
        LPAD("geo_id", 5, '0') AS County_FIPS,
        ("poverty" / "pop_determined_poverty_status") * 100 AS poverty_rate
    FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2016_5YR
    WHERE
        "pop_determined_poverty_status" > 0
    UNION ALL
    SELECT
        '2018-01-01' AS Year,
        LPAD("geo_id", 5, '0') AS County_FIPS,
        ("poverty" / "pop_determined_poverty_status") * 100 AS poverty_rate
    FROM
        SDOH.CENSUS_BUREAU_ACS.COUNTY_2017_5YR
    WHERE
        "pop_determined_poverty_status" > 0
)
SELECT
    ROUND(CORR(n.Percent_Births_Without_Morbidity, p.poverty_rate), 4) AS "Pearson_correlation_coefficient"
FROM
    natality_data n
JOIN
    poverty_data p
ON
    n."Year" = p.Year AND n.County_FIPS = p.County_FIPS;