WITH data2014 AS (
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
    FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
    WHERE "report_year" = 2014 AND "workforce" = 'overall'
),
data2024 AS (
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
    FROM GOOGLE_DEI.GOOGLE_DEI.DAR_NON_INTERSECTIONAL_REPRESENTATION
    WHERE "report_year" = 2024 AND "workforce" = 'overall'
),
rates AS (
    SELECT
        'Asian' AS "Group",
        (d2024."race_asian" - d2014."race_asian") / d2014."race_asian" AS "Growth_Rate"
    FROM data2014 d2014 CROSS JOIN data2024 d2024
    UNION ALL
    SELECT
        'Black' AS "Group",
        (d2024."race_black" - d2014."race_black") / d2014."race_black" AS "Growth_Rate"
    FROM data2014 d2014 CROSS JOIN data2024 d2024
    UNION ALL
    SELECT
        'Global Men' AS "Group",
        (d2024."gender_global_men" - d2014."gender_global_men") / d2014."gender_global_men" AS "Growth_Rate"
    FROM data2014 d2014 CROSS JOIN data2024 d2024
    UNION ALL
    SELECT
        'Global Women' AS "Group",
        (d2024."gender_global_women" - d2014."gender_global_women") / d2014."gender_global_women" AS "Growth_Rate"
    FROM data2014 d2014 CROSS JOIN data2024 d2024
    UNION ALL
    SELECT
        'Latinx' AS "Group",
        (d2024."race_hispanic_latinx" - d2014."race_hispanic_latinx") / d2014."race_hispanic_latinx" AS "Growth_Rate"
    FROM data2014 d2014 CROSS JOIN data2024 d2024
    UNION ALL
    SELECT
        'Native American' AS "Group",
        (d2024."race_native_american" - d2014."race_native_american") / d2014."race_native_american" AS "Growth_Rate"
    FROM data2014 d2014 CROSS JOIN data2024 d2024
    UNION ALL
    SELECT
        'US Men' AS "Group",
        (d2024."gender_us_men" - d2014."gender_us_men") / d2014."gender_us_men" AS "Growth_Rate"
    FROM data2014 d2014 CROSS JOIN data2024 d2024
    UNION ALL
    SELECT
        'US Women' AS "Group",
        (d2024."gender_us_women" - d2014."gender_us_women") / d2014."gender_us_women" AS "Growth_Rate"
    FROM data2014 d2014 CROSS JOIN data2024 d2024
    UNION ALL
    SELECT
        'White' AS "Group",
        (d2024."race_white" - d2014."race_white") / d2014."race_white" AS "Growth_Rate"
    FROM data2014 d2014 CROSS JOIN data2024 d2024
)
SELECT
    "Group",
    ROUND("Growth_Rate", 4) AS "Growth_Rate"
FROM rates
ORDER BY "Group";