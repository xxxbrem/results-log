WITH data_2014 AS (
    SELECT 
        "race_asian", "race_black", "race_hispanic_latinx", "race_native_american", "race_white",
        "gender_us_women", "gender_us_men", "gender_global_women", "gender_global_men"
    FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
    WHERE "workforce" = 'overall' AND "report_year" = 2014
),
data_2024 AS (
    SELECT 
        "race_asian", "race_black", "race_hispanic_latinx", "race_native_american", "race_white",
        "gender_us_women", "gender_us_men", "gender_global_women", "gender_global_men"
    FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
    WHERE "workforce" = 'overall' AND "report_year" = 2024
)
SELECT 'Asians' AS Demographic_group,
       ROUND(((d2024."race_asian" - d2014."race_asian") / d2014."race_asian") * 100, 4) AS Growth_rate
FROM data_2014 d2014, data_2024 d2024
UNION ALL
SELECT 'Black people',
       ROUND(((d2024."race_black" - d2014."race_black") / d2014."race_black") * 100, 4)
FROM data_2014 d2014, data_2024 d2024
UNION ALL
SELECT 'Latinx people',
       ROUND(((d2024."race_hispanic_latinx" - d2014."race_hispanic_latinx") / d2014."race_hispanic_latinx") * 100, 4)
FROM data_2014 d2014, data_2024 d2024
UNION ALL
SELECT 'Native Americans',
       ROUND(((d2024."race_native_american" - d2014."race_native_american") / d2014."race_native_american") * 100, 4)
FROM data_2014 d2014, data_2024 d2024
UNION ALL
SELECT 'White people',
       ROUND(((d2024."race_white" - d2014."race_white") / d2014."race_white") * 100, 4)
FROM data_2014 d2014, data_2024 d2024
UNION ALL
SELECT 'US women',
       ROUND(((d2024."gender_us_women" - d2014."gender_us_women") / d2014."gender_us_women") * 100, 4)
FROM data_2014 d2014, data_2024 d2024
UNION ALL
SELECT 'US men',
       ROUND(((d2024."gender_us_men" - d2014."gender_us_men") / d2014."gender_us_men") * 100, 4)
FROM data_2014 d2014, data_2024 d2024
UNION ALL
SELECT 'Global women',
       ROUND(((d2024."gender_global_women" - d2014."gender_global_women") / d2014."gender_global_women") * 100, 4)
FROM data_2014 d2014, data_2024 d2024
UNION ALL
SELECT 'Global men',
       ROUND(((d2024."gender_global_men" - d2014."gender_global_men") / d2014."gender_global_men") * 100, 4)
FROM data_2014 d2014, data_2024 d2024;