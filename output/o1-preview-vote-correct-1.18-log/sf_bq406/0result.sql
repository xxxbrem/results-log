WITH data_2014 AS (
    SELECT
        "race_asian",
        "race_black",
        "race_hispanic_latinx",
        "race_native_american",
        "race_white",
        "gender_us_women",
        "gender_us_men",
        "gender_global_women",
        "gender_global_men"
    FROM
        GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
    WHERE
        "report_year" = 2014 AND
        "workforce" = 'overall'
),
data_2023 AS (
    SELECT
        "race_asian",
        "race_black",
        "race_hispanic_latinx",
        "race_native_american",
        "race_white",
        "gender_us_women",
        "gender_us_men",
        "gender_global_women",
        "gender_global_men"
    FROM
        GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
    WHERE
        "report_year" = 2023 AND
        "workforce" = 'overall'
)
SELECT
    'Asians' AS "Demographic_Group",
    ROUND(((d23."race_asian" - d14."race_asian") / d14."race_asian") * 100, 4) AS "Growth_Rate"
FROM data_2014 d14, data_2023 d23

UNION ALL

SELECT
    'Black people' AS "Demographic_Group",
    ROUND(((d23."race_black" - d14."race_black") / d14."race_black") * 100, 4) AS "Growth_Rate"
FROM data_2014 d14, data_2023 d23

UNION ALL

SELECT
    'Latinx people' AS "Demographic_Group",
    ROUND(((d23."race_hispanic_latinx" - d14."race_hispanic_latinx") / d14."race_hispanic_latinx") * 100, 4) AS "Growth_Rate"
FROM data_2014 d14, data_2023 d23

UNION ALL

SELECT
    'Native Americans' AS "Demographic_Group",
    ROUND(((d23."race_native_american" - d14."race_native_american") / d14."race_native_american") * 100, 4) AS "Growth_Rate"
FROM data_2014 d14, data_2023 d23

UNION ALL

SELECT
    'White people' AS "Demographic_Group",
    ROUND(((d23."race_white" - d14."race_white") / d14."race_white") * 100, 4) AS "Growth_Rate"
FROM data_2014 d14, data_2023 d23

UNION ALL

SELECT
    'US women' AS "Demographic_Group",
    ROUND(((d23."gender_us_women" - d14."gender_us_women") / d14."gender_us_women") * 100, 4) AS "Growth_Rate"
FROM data_2014 d14, data_2023 d23

UNION ALL

SELECT
    'US men' AS "Demographic_Group",
    ROUND(((d23."gender_us_men" - d14."gender_us_men") / d14."gender_us_men") * 100, 4) AS "Growth_Rate"
FROM data_2014 d14, data_2023 d23

UNION ALL

SELECT
    'Global women' AS "Demographic_Group",
    ROUND(((d23."gender_global_women" - d14."gender_global_women") / d14."gender_global_women") * 100, 4) AS "Growth_Rate"
FROM data_2014 d14, data_2023 d23

UNION ALL

SELECT
    'Global men' AS "Demographic_Group",
    ROUND(((d23."gender_global_men" - d14."gender_global_men") / d14."gender_global_men") * 100, 4) AS "Growth_Rate"
FROM data_2014 d14, data_2023 d23;