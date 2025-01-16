WITH total_crimes AS (
    SELECT "year", SUM("value") AS "total_crimes"
    FROM LONDON.LONDON_CRIME."CRIME_BY_LSOA"
    GROUP BY "year"
),
category_crimes AS (
    SELECT
        "year",
        SUM(CASE WHEN "minor_category" = 'Other Theft' THEN "value" ELSE 0 END) AS "category_1_crimes",
        SUM(CASE WHEN "minor_category" = 'Theft From Motor Vehicle' THEN "value" ELSE 0 END) AS "category_2_crimes",
        SUM(CASE WHEN "minor_category" = 'Possession Of Drugs' THEN "value" ELSE 0 END) AS "category_3_crimes",
        SUM(CASE WHEN "minor_category" = 'Burglary in a Dwelling' THEN "value" ELSE 0 END) AS "category_4_crimes",
        SUM(CASE WHEN "minor_category" = 'Assault with Injury' THEN "value" ELSE 0 END) AS "category_5_crimes"
    FROM LONDON.LONDON_CRIME."CRIME_BY_LSOA"
    GROUP BY "year"
)
SELECT
    c."year" AS "Year",
    'Other Theft' AS "Minor_Category_1_Name",
    ROUND(100 * c."category_1_crimes" / t."total_crimes", 4) AS "Percentage_Share_1",
    'Theft From Motor Vehicle' AS "Minor_Category_2_Name",
    ROUND(100 * c."category_2_crimes" / t."total_crimes", 4) AS "Percentage_Share_2",
    'Possession Of Drugs' AS "Minor_Category_3_Name",
    ROUND(100 * c."category_3_crimes" / t."total_crimes", 4) AS "Percentage_Share_3",
    'Burglary in a Dwelling' AS "Minor_Category_4_Name",
    ROUND(100 * c."category_4_crimes" / t."total_crimes", 4) AS "Percentage_Share_4",
    'Assault with Injury' AS "Minor_Category_5_Name",
    ROUND(100 * c."category_5_crimes" / t."total_crimes", 4) AS "Percentage_Share_5"
FROM category_crimes c
JOIN total_crimes t ON c."year" = t."year"
ORDER BY c."year";