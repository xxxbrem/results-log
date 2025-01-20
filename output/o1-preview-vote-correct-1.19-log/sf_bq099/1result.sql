WITH data AS (
    SELECT
        a.value:"name"::STRING AS "assignee_name",
        FLOOR(t."publication_date" / 10000.0) AS "publication_year",
        t."country_code"
    FROM
        PATENTS.PATENTS.PUBLICATIONS t,
        LATERAL FLATTEN(input => t."cpc") f,
        LATERAL FLATTEN(input => t."assignee_harmonized") a
    WHERE
        f.value:"code"::STRING LIKE 'A01B3%'
),
top_assignees AS (
    SELECT
        "assignee_name",
        COUNT(*) AS "total_applications"
    FROM data
    GROUP BY "assignee_name"
    ORDER BY "total_applications" DESC NULLS LAST
    LIMIT 3
),
assignee_year_counts AS (
    SELECT
        d."assignee_name",
        d."publication_year",
        COUNT(*) AS "applications_in_year"
    FROM
        data d
    JOIN top_assignees t ON d."assignee_name" = t."assignee_name"
    GROUP BY d."assignee_name", d."publication_year"
),
assignee_top_year AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY "assignee_name" ORDER BY "applications_in_year" DESC, "publication_year") AS "rn"
    FROM
        assignee_year_counts
),
top_country AS (
    SELECT
        d."assignee_name",
        d."publication_year",
        d."country_code",
        COUNT(*) AS "country_application_count",
        ROW_NUMBER() OVER (
            PARTITION BY d."assignee_name", d."publication_year"
            ORDER BY COUNT(*) DESC NULLS LAST, d."country_code"
        ) AS "rn"
    FROM
        data d
    JOIN (
            SELECT "assignee_name", "publication_year"
            FROM assignee_top_year
            WHERE "rn" = 1
        ) aty ON d."assignee_name" = aty."assignee_name" AND d."publication_year" = aty."publication_year"
    GROUP BY
        d."assignee_name",
        d."publication_year",
        d."country_code"
)
SELECT
    ta."assignee_name",
    ta."total_applications",
    aty."publication_year" AS "top_year",
    aty."applications_in_year",
    tc."country_code" AS "top_country_code"
FROM
    top_assignees ta
JOIN (
    SELECT "assignee_name", "publication_year", "applications_in_year"
    FROM assignee_top_year
    WHERE "rn" = 1
) aty ON ta."assignee_name" = aty."assignee_name"
JOIN (
    SELECT "assignee_name", "publication_year", "country_code"
    FROM top_country
    WHERE "rn" = 1
) tc ON ta."assignee_name" = tc."assignee_name" AND aty."publication_year" = tc."publication_year";