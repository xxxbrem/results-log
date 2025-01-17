WITH data AS (
  SELECT "report_year", 'Asians' AS "Group", "race_asian" AS "Percentage"
  FROM "GOOGLE_DEI"."GOOGLE_DEI"."DAR_NON_INTERSECTIONAL_REPRESENTATION"
  WHERE LOWER("workforce") = 'overall' AND "report_year" IN (2014, 2024)
  UNION ALL
  SELECT "report_year", 'Black people', "race_black"
  FROM "GOOGLE_DEI"."GOOGLE_DEI"."DAR_NON_INTERSECTIONAL_REPRESENTATION"
  WHERE LOWER("workforce") = 'overall' AND "report_year" IN (2014, 2024)
  UNION ALL
  SELECT "report_year", 'Latinx people', "race_hispanic_latinx"
  FROM "GOOGLE_DEI"."GOOGLE_DEI"."DAR_NON_INTERSECTIONAL_REPRESENTATION"
  WHERE LOWER("workforce") = 'overall' AND "report_year" IN (2014, 2024)
  UNION ALL
  SELECT "report_year", 'Native Americans', "race_native_american"
  FROM "GOOGLE_DEI"."GOOGLE_DEI"."DAR_NON_INTERSECTIONAL_REPRESENTATION"
  WHERE LOWER("workforce") = 'overall' AND "report_year" IN (2014, 2024)
  UNION ALL
  SELECT "report_year", 'White people', "race_white"
  FROM "GOOGLE_DEI"."GOOGLE_DEI"."DAR_NON_INTERSECTIONAL_REPRESENTATION"
  WHERE LOWER("workforce") = 'overall' AND "report_year" IN (2014, 2024)
  UNION ALL
  SELECT "report_year", 'US women', "gender_us_women"
  FROM "GOOGLE_DEI"."GOOGLE_DEI"."DAR_NON_INTERSECTIONAL_REPRESENTATION"
  WHERE LOWER("workforce") = 'overall' AND "report_year" IN (2014, 2024)
  UNION ALL
  SELECT "report_year", 'US men', "gender_us_men"
  FROM "GOOGLE_DEI"."GOOGLE_DEI"."DAR_NON_INTERSECTIONAL_REPRESENTATION"
  WHERE LOWER("workforce") = 'overall' AND "report_year" IN (2014, 2024)
  UNION ALL
  SELECT "report_year", 'Global women', "gender_global_women"
  FROM "GOOGLE_DEI"."GOOGLE_DEI"."DAR_NON_INTERSECTIONAL_REPRESENTATION"
  WHERE LOWER("workforce") = 'overall' AND "report_year" IN (2014, 2024)
  UNION ALL
  SELECT "report_year", 'Global men', "gender_global_men"
  FROM "GOOGLE_DEI"."GOOGLE_DEI"."DAR_NON_INTERSECTIONAL_REPRESENTATION"
  WHERE LOWER("workforce") = 'overall' AND "report_year" IN (2014, 2024)
)
SELECT
  "Group",
  ROUND(
    (MAX(CASE WHEN "report_year" = 2024 THEN "Percentage" END) - MAX(CASE WHEN "report_year" = 2014 THEN "Percentage" END)) 
    / MAX(CASE WHEN "report_year" = 2014 THEN "Percentage" END), 4
  ) AS "Growth_Rate"
FROM data
GROUP BY "Group"
ORDER BY "Group";