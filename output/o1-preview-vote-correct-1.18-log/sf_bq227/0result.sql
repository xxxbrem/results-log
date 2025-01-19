WITH top5_categories AS (
    SELECT "minor_category"
    FROM (
        SELECT "minor_category", SUM("value") AS "total_crimes"
        FROM LONDON.LONDON_CRIME.CRIME_BY_LSOA
        WHERE "year" = 2008
        GROUP BY "minor_category"
        ORDER BY SUM("value") DESC NULLS LAST
        LIMIT 5
    )
),
category_totals AS (
    SELECT "year", "minor_category", SUM("value") AS "category_total"
    FROM LONDON.LONDON_CRIME.CRIME_BY_LSOA
    WHERE "minor_category" IN (SELECT "minor_category" FROM top5_categories)
    GROUP BY "year", "minor_category"
),
year_totals AS (
    SELECT "year", SUM("value") AS "year_total"
    FROM LONDON.LONDON_CRIME.CRIME_BY_LSOA
    GROUP BY "year"
),
percentages AS (
    SELECT 
        yt."year" AS "Year",
        ROUND(100.0 * SUM(CASE WHEN ct."minor_category" = 'Other Theft' THEN ct."category_total" ELSE 0 END) / yt."year_total", 4) AS "Other Theft",
        ROUND(100.0 * SUM(CASE WHEN ct."minor_category" = 'Theft From Motor Vehicle' THEN ct."category_total" ELSE 0 END) / yt."year_total", 4) AS "Theft From Motor Vehicle",
        ROUND(100.0 * SUM(CASE WHEN ct."minor_category" = 'Possession Of Drugs' THEN ct."category_total" ELSE 0 END) / yt."year_total", 4) AS "Possession Of Drugs",
        ROUND(100.0 * SUM(CASE WHEN ct."minor_category" = 'Burglary in a Dwelling' THEN ct."category_total" ELSE 0 END) / yt."year_total", 4) AS "Burglary in a Dwelling",
        ROUND(100.0 * SUM(CASE WHEN ct."minor_category" = 'Assault with Injury' THEN ct."category_total" ELSE 0 END) / yt."year_total", 4) AS "Assault with Injury"
    FROM year_totals yt
    LEFT JOIN category_totals ct ON yt."year" = ct."year"
    GROUP BY yt."year", yt."year_total"
    ORDER BY yt."year" NULLS LAST
)
SELECT *
FROM percentages;