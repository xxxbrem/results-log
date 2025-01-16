SELECT n."County_of_Residence" AS "County_Name",
       ROUND(n."Ave_Number_of_Prenatal_Wks", 4) AS "Average_Prenatal_Weeks_2018"
FROM SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY AS n
JOIN SDOH.CENSUS_BUREAU_ACS.COUNTY_2017_5YR AS c
  ON n."County_of_Residence_FIPS" = c."geo_id"
WHERE n."Year" = '2018-01-01'
  AND LEFT(n."County_of_Residence_FIPS", 2) = '55'  -- Wisconsin state FIPS code is 55
  AND c."employed_pop" > 0
  AND ((c."commute_45_59_mins" / c."employed_pop") * 100) > 5;