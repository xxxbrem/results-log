SELECT 'Asians' AS "Demographic",
       ROUND(((end_data."race_asian" - start_data."race_asian") / start_data."race_asian") * 100, 4) AS "Growth_rate"
FROM
    (SELECT "race_asian"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2014) AS start_data,
    (SELECT "race_asian"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2024) AS end_data

UNION ALL

SELECT 'Black_people',
       ROUND(((end_data."race_black" - start_data."race_black") / start_data."race_black") * 100, 4)
FROM
    (SELECT "race_black"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2014) AS start_data,
    (SELECT "race_black"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2024) AS end_data

UNION ALL

SELECT 'Latinx_people',
       ROUND(((end_data."race_hispanic_latinx" - start_data."race_hispanic_latinx") / start_data."race_hispanic_latinx") * 100, 4)
FROM
    (SELECT "race_hispanic_latinx"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2014) AS start_data,
    (SELECT "race_hispanic_latinx"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2024) AS end_data

UNION ALL

SELECT 'Native_Americans',
       ROUND(((end_data."race_native_american" - start_data."race_native_american") / start_data."race_native_american") * 100, 4)
FROM
    (SELECT "race_native_american"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2014) AS start_data,
    (SELECT "race_native_american"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2024) AS end_data

UNION ALL

SELECT 'White_people',
       ROUND(((end_data."race_white" - start_data."race_white") / start_data."race_white") * 100, 4)
FROM
    (SELECT "race_white"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2014) AS start_data,
    (SELECT "race_white"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2024) AS end_data

UNION ALL

SELECT 'US_women',
       ROUND(((end_data."gender_us_women" - start_data."gender_us_women") / start_data."gender_us_women") * 100, 4)
FROM
    (SELECT "gender_us_women"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2014) AS start_data,
    (SELECT "gender_us_women"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2024) AS end_data

UNION ALL

SELECT 'US_men',
       ROUND(((end_data."gender_us_men" - start_data."gender_us_men") / start_data."gender_us_men") * 100, 4)
FROM
    (SELECT "gender_us_men"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2014) AS start_data,
    (SELECT "gender_us_men"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2024) AS end_data

UNION ALL

SELECT 'global_women',
       ROUND(((end_data."gender_global_women" - start_data."gender_global_women") / start_data."gender_global_women") * 100, 4)
FROM
    (SELECT "gender_global_women"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2014) AS start_data,
    (SELECT "gender_global_women"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2024) AS end_data

UNION ALL

SELECT 'global_men',
       ROUND(((end_data."gender_global_men" - start_data."gender_global_men") / start_data."gender_global_men") * 100, 4)
FROM
    (SELECT "gender_global_men"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2014) AS start_data,
    (SELECT "gender_global_men"
     FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
     WHERE "workforce" = 'overall' AND "report_year" = 2024) AS end_data;