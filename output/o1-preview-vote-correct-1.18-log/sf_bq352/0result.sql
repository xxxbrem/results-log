SELECT 
    N."County_of_Residence" AS "County", 
    ROUND(N."Ave_Number_of_Prenatal_Wks", 4) AS "Ave_Number_of_Prenatal_Wks"
FROM 
    SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY N
JOIN 
    SDOH.CENSUS_BUREAU_ACS.COUNTY_2017_5YR C
    ON N."County_of_Residence_FIPS" = CAST(C."geo_id" AS VARCHAR)
WHERE
    N."Year" = '2018-01-01' AND
    N."County_of_Residence_FIPS" LIKE '55%' AND
    C."employed_pop" > 0 AND
    (C."commute_45_59_mins" / C."employed_pop") * 100 > 5