WITH a01b3_applications AS (
    SELECT
        t."publication_number",
        t."application_number",
        t."filing_date",
        t."country_code" AS country_code,
        assignee_f.value:"name"::STRING AS assignee_name,
        TO_NUMBER(SUBSTR(t."filing_date"::STRING, 1, 4)) AS filing_year,
        PARSE_JSON(f.value::STRING):"code"::STRING AS cpc_code
    FROM
        "PATENTS"."PATENTS"."PUBLICATIONS" t,
        LATERAL FLATTEN(input => t."cpc") f,
        LATERAL FLATTEN(input => t."assignee_harmonized") assignee_f
    WHERE
        PARSE_JSON(f.value::STRING):"code"::STRING LIKE 'A01B3%'
        AND assignee_f.value:"name"::STRING IS NOT NULL
        AND t."filing_date" IS NOT NULL
),
total_apps AS (
    SELECT
        assignee_name,
        COUNT(DISTINCT "application_number") AS total_applications
    FROM
        a01b3_applications
    GROUP BY
        assignee_name
),
apps_per_year AS (
    SELECT
        assignee_name,
        filing_year,
        COUNT(DISTINCT "application_number") AS applications_in_year
    FROM
        a01b3_applications
    GROUP BY
        assignee_name,
        filing_year
),
max_apps_year AS (
    SELECT
        assignee_name,
        filing_year AS year_with_most_apps,
        applications_in_year,
        ROW_NUMBER() OVER (
            PARTITION BY assignee_name
            ORDER BY applications_in_year DESC, filing_year ASC
        ) AS rn
    FROM
        apps_per_year
    WHERE applications_in_year IS NOT NULL
),
country_with_most_apps AS (
    SELECT
        assignee_name,
        filing_year,
        country_code,
        applications_in_country,
        ROW_NUMBER() OVER (
            PARTITION BY assignee_name, filing_year
            ORDER BY applications_in_country DESC, country_code ASC
        ) AS rn
    FROM (
        SELECT
            assignee_name,
            filing_year,
            country_code,
            COUNT(DISTINCT "application_number") AS applications_in_country
        FROM
            a01b3_applications
        GROUP BY
            assignee_name,
            filing_year,
            country_code
    )
)
SELECT
    ta.assignee_name AS "Name of Assignee",
    ta.total_applications AS "Total Number of Applications",
    may.year_with_most_apps AS "Year with Most Applications",
    may.applications_in_year AS "Number of Applications in That Year",
    cma.country_code AS "Country Code with Most Applications During That Year"
FROM
    total_apps ta
JOIN
    max_apps_year may
    ON ta.assignee_name = may.assignee_name AND may.rn = 1
LEFT JOIN
    country_with_most_apps cma
    ON ta.assignee_name = cma.assignee_name
    AND may.year_with_most_apps = cma.filing_year
    AND cma.rn = 1
ORDER BY
    ta.total_applications DESC NULLS LAST,
    ta.assignee_name ASC
LIMIT 3;