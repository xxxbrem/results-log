WITH class_a01b3 AS (
    SELECT
        t."application_number",
        a.value::STRING AS "assignee_name",
        EXTRACT(year FROM TRY_TO_DATE(t."publication_date"::STRING, 'YYYYMMDD')) AS "publication_year",
        t."country_code"
    FROM PATENTS.PATENTS.PUBLICATIONS t,
         LATERAL FLATTEN(input => t."cpc") c,
         LATERAL FLATTEN(input => t."assignee") a
    WHERE c.value:"code"::STRING ILIKE 'A01B3%'
        AND a.value IS NOT NULL
        AND TRY_TO_DATE(t."publication_date"::STRING, 'YYYYMMDD') IS NOT NULL
),
assignee_totals AS (
    SELECT 
        "assignee_name", 
        COUNT(DISTINCT "application_number") AS "total_applications"
    FROM class_a01b3
    GROUP BY "assignee_name"
),
top_assignees AS (
    SELECT "assignee_name", "total_applications"
    FROM assignee_totals
    WHERE "assignee_name" IS NOT NULL
    ORDER BY "total_applications" DESC NULLS LAST, "assignee_name"
    LIMIT 3
),
assignee_year_counts AS (
    SELECT
        "assignee_name",
        "publication_year",
        COUNT(DISTINCT "application_number") AS "applications_in_year"
    FROM class_a01b3
    WHERE "assignee_name" IN (SELECT "assignee_name" FROM top_assignees)
    GROUP BY "assignee_name", "publication_year"
),
assignee_most_active_year AS (
    SELECT
        "assignee_name",
        "publication_year" AS "most_active_year",
        "applications_in_year",
        RANK() OVER(PARTITION BY "assignee_name" ORDER BY "applications_in_year" DESC NULLS LAST, "publication_year") AS "rank"
    FROM assignee_year_counts
),
assignee_top_year AS (
    SELECT *
    FROM assignee_most_active_year
    WHERE "rank" = 1
),
assignee_country_counts AS (
    SELECT
        c."assignee_name",
        c."publication_year",
        c."country_code",
        COUNT(DISTINCT c."application_number") AS "applications_in_country"
    FROM class_a01b3 c
    JOIN assignee_top_year aty
        ON c."assignee_name" = aty."assignee_name"
        AND c."publication_year" = aty."most_active_year"
    GROUP BY c."assignee_name", c."publication_year", c."country_code"
),
assignee_top_country AS (
    SELECT
        acc."assignee_name",
        acc."publication_year",
        acc."country_code" AS "top_country_code",
        acc."applications_in_country",
        RANK() OVER (PARTITION BY acc."assignee_name", acc."publication_year" ORDER BY acc."applications_in_country" DESC NULLS LAST, acc."country_code") AS "rank"
    FROM assignee_country_counts acc
)
SELECT
    ta."assignee_name" AS "Assignee_Name",
    ta."total_applications" AS "Total_Applications",
    aty."most_active_year" AS "Most_Active_Year",
    aty."applications_in_year" AS "Applications_in_That_Year",
    atc."top_country_code" AS "Top_Country_Code_in_That_Year"
FROM
    top_assignees ta
JOIN
    assignee_top_year aty ON ta."assignee_name" = aty."assignee_name"
JOIN
    assignee_top_country atc ON ta."assignee_name" = atc."assignee_name" AND aty."most_active_year" = atc."publication_year" AND atc."rank" = 1
ORDER BY ta."total_applications" DESC NULLS LAST, ta."assignee_name";