SELECT n."County_of_Residence", ROUND(n."Ave_Number_of_Prenatal_Wks", 4) AS "Ave_Number_of_Prenatal_Wks"
FROM SDOH.SDOH_CDC_WONDER_NATALITY.COUNTY_NATALITY AS n
JOIN SDOH.CENSUS_BUREAU_ACS.COUNTY_2017_5YR AS a
  ON n."County_of_Residence_FIPS" = RIGHT(a."geo_id", 5)
WHERE EXTRACT(YEAR FROM n."Year") = 2018
  AND LEFT(n."County_of_Residence_FIPS", 2) = '55'
  AND ((a."commute_45_59_mins" / NULLIF(a."employed_pop", 0)) * 100) > 5;