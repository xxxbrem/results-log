SELECT
    t2."County_of_Residence" AS "County_Name",
    ROUND(t2."Ave_Number_of_Prenatal_Wks", 4) AS "Ave_Number_of_Prenatal_Weeks"
FROM
    SDOH.CENSUS_BUREAU_ACS.COUNTY_2017_5YR t1
JOIN
    SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY t2
ON
    LPAD(t1."geo_id", 5, '0') = t2."County_of_Residence_FIPS"
WHERE
    LEFT(LPAD(t1."geo_id", 5, '0'), 2) = '55'  -- Wisconsin state FIPS code
    AND t2."Year" = '2018-01-01'
    AND t1."commuters_16_over" > 0
    AND (t1."commute_45_59_mins" / t1."commuters_16_over") * 100 > 5;