SELECT
  ROUND(((asian_2023 - asian_2014) / asian_2014) * 100, 4) AS "Asian",
  ROUND(((black_2023 - black_2014) / black_2014) * 100, 4) AS "Black",
  ROUND(((latinx_2023 - latinx_2014) / latinx_2014) * 100, 4) AS "Latinx",
  ROUND(((native_american_2023 - native_american_2014) / native_american_2014) * 100, 4) AS "Native_American",
  ROUND(((white_2023 - white_2014) / white_2014) * 100, 4) AS "White",
  ROUND(((us_women_2023 - us_women_2014) / us_women_2014) * 100, 4) AS "US_women",
  ROUND(((us_men_2023 - us_men_2014) / us_men_2014) * 100, 4) AS "US_men",
  ROUND(((global_women_2023 - global_women_2014) / global_women_2014) * 100, 4) AS "Global_women",
  ROUND(((global_men_2023 - global_men_2014) / global_men_2014) * 100, 4) AS "Global_men"
FROM (
  SELECT
    MAX(CASE WHEN "report_year" = 2014 AND "workforce" = 'overall' THEN "race_asian" END) AS asian_2014,
    MAX(CASE WHEN "report_year" = 2023 AND "workforce" = 'overall' THEN "race_asian" END) AS asian_2023,
    MAX(CASE WHEN "report_year" = 2014 AND "workforce" = 'overall' THEN "race_black" END) AS black_2014,
    MAX(CASE WHEN "report_year" = 2023 AND "workforce" = 'overall' THEN "race_black" END) AS black_2023,
    MAX(CASE WHEN "report_year" = 2014 AND "workforce" = 'overall' THEN "race_hispanic_latinx" END) AS latinx_2014,
    MAX(CASE WHEN "report_year" = 2023 AND "workforce" = 'overall' THEN "race_hispanic_latinx" END) AS latinx_2023,
    MAX(CASE WHEN "report_year" = 2014 AND "workforce" = 'overall' THEN "race_native_american" END) AS native_american_2014,
    MAX(CASE WHEN "report_year" = 2023 AND "workforce" = 'overall' THEN "race_native_american" END) AS native_american_2023,
    MAX(CASE WHEN "report_year" = 2014 AND "workforce" = 'overall' THEN "race_white" END) AS white_2014,
    MAX(CASE WHEN "report_year" = 2023 AND "workforce" = 'overall' THEN "race_white" END) AS white_2023,
    MAX(CASE WHEN "report_year" = 2014 AND "workforce" = 'overall' THEN "gender_us_women" END) AS us_women_2014,
    MAX(CASE WHEN "report_year" = 2023 AND "workforce" = 'overall' THEN "gender_us_women" END) AS us_women_2023,
    MAX(CASE WHEN "report_year" = 2014 AND "workforce" = 'overall' THEN "gender_us_men" END) AS us_men_2014,
    MAX(CASE WHEN "report_year" = 2023 AND "workforce" = 'overall' THEN "gender_us_men" END) AS us_men_2023,
    MAX(CASE WHEN "report_year" = 2014 AND "workforce" = 'overall' THEN "gender_global_women" END) AS global_women_2014,
    MAX(CASE WHEN "report_year" = 2023 AND "workforce" = 'overall' THEN "gender_global_women" END) AS global_women_2023,
    MAX(CASE WHEN "report_year" = 2014 AND "workforce" = 'overall' THEN "gender_global_men" END) AS global_men_2014,
    MAX(CASE WHEN "report_year" = 2023 AND "workforce" = 'overall' THEN "gender_global_men" END) AS global_men_2023
  FROM "GOOGLE_DEI"."GOOGLE_DEI"."DAR_NON_INTERSECTIONAL_REPRESENTATION"
) AS sub;