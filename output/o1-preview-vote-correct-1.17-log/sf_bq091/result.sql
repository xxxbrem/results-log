WITH relevant_publications AS (
    SELECT
        f.value::VARIANT:"name"::STRING AS "assignee_name",
        SUBSTRING(t."filing_date"::STRING, 1, 4) AS "filing_year",
        t."publication_number"
    FROM PATENTS.PATENTS.PUBLICATIONS t,
         LATERAL FLATTEN(input => t."assignee_harmonized") f,
         LATERAL FLATTEN(input => t."cpc") c
    WHERE c.value::VARIANT:"code"::STRING LIKE 'A61%'
      AND t."filing_date" IS NOT NULL
),
assignee_total_applications AS (
    SELECT
        "assignee_name",
        COUNT(DISTINCT "publication_number") AS "total_applications"
    FROM relevant_publications
    GROUP BY "assignee_name"
),
top_assignee AS (
    SELECT "assignee_name"
    FROM assignee_total_applications
    ORDER BY "total_applications" DESC NULLS LAST
    LIMIT 1
),
assignee_year_applications AS (
    SELECT
        "assignee_name",
        "filing_year",
        COUNT(DISTINCT "publication_number") AS "number_of_applications"
    FROM relevant_publications
    WHERE "assignee_name" = (SELECT "assignee_name" FROM top_assignee)
    GROUP BY "assignee_name", "filing_year"
    ORDER BY "number_of_applications" DESC NULLS LAST
    LIMIT 1
)
SELECT
    "assignee_name" AS assignee,
    "filing_year" AS year,
    "number_of_applications"
FROM assignee_year_applications;