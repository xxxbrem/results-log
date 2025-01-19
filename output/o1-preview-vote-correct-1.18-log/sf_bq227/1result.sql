WITH top5 AS (
    SELECT "minor_category", ROW_NUMBER() OVER (ORDER BY SUM("value") DESC NULLS LAST) AS rn
    FROM LONDON.LONDON_CRIME.CRIME_BY_LSOA
    WHERE "year" = 2008
    GROUP BY "minor_category"
    ORDER BY SUM("value") DESC NULLS LAST
    LIMIT 5
),
total_crimes_per_year AS (
    SELECT "year", SUM("value") AS total_crimes
    FROM LONDON.LONDON_CRIME.CRIME_BY_LSOA
    WHERE "year" >= 2008
    GROUP BY "year"
)
SELECT
    c."year" AS "Year",
    ROUND(SUM(CASE WHEN c."minor_category" = (SELECT "minor_category" FROM top5 WHERE rn = 1) THEN c."value" ELSE 0 END) * 100.0 / t.total_crimes, 4) AS "Minor_Category_1",
    ROUND(SUM(CASE WHEN c."minor_category" = (SELECT "minor_category" FROM top5 WHERE rn = 2) THEN c."value" ELSE 0 END) * 100.0 / t.total_crimes, 4) AS "Minor_Category_2",
    ROUND(SUM(CASE WHEN c."minor_category" = (SELECT "minor_category" FROM top5 WHERE rn = 3) THEN c."value" ELSE 0 END) * 100.0 / t.total_crimes, 4) AS "Minor_Category_3",
    ROUND(SUM(CASE WHEN c."minor_category" = (SELECT "minor_category" FROM top5 WHERE rn = 4) THEN c."value" ELSE 0 END) * 100.0 / t.total_crimes, 4) AS "Minor_Category_4",
    ROUND(SUM(CASE WHEN c."minor_category" = (SELECT "minor_category" FROM top5 WHERE rn = 5) THEN c."value" ELSE 0 END) * 100.0 / t.total_crimes, 4) AS "Minor_Category_5"
FROM LONDON.LONDON_CRIME.CRIME_BY_LSOA c
JOIN total_crimes_per_year t ON c."year" = t."year"
WHERE c."year" >= 2008
GROUP BY c."year", t.total_crimes
ORDER BY c."year" NULLS LAST;