WITH cpc_applications AS (
    SELECT
        t."publication_number",
        t."filing_date",
        t."country_code",
        a.value:"name"::STRING AS "assignee_name",
        TO_CHAR(TRY_TO_DATE(t."filing_date"::STRING, 'YYYYMMDD'), 'YYYY') AS "filing_year"
    FROM
        "PATENTS"."PATENTS"."PUBLICATIONS" t,
        LATERAL FLATTEN(input => t."cpc") c,
        LATERAL FLATTEN(input => t."assignee_harmonized") a
    WHERE
        c.value:"code"::STRING LIKE 'A01B3%'
        AND a.value:"name"::STRING IS NOT NULL
        AND t."filing_date" IS NOT NULL
),
assignee_totals AS (
    SELECT
        "assignee_name",
        COUNT(DISTINCT "publication_number") AS "total_number_of_applications"
    FROM
        cpc_applications
    GROUP BY
        "assignee_name"
),
top_assignees AS (
    SELECT
        "assignee_name",
        "total_number_of_applications"
    FROM
        assignee_totals
    ORDER BY
        "total_number_of_applications" DESC NULLS LAST,
        "assignee_name"
    LIMIT 3
),
assignee_years AS (
    SELECT
        cpc_applications."assignee_name",
        cpc_applications."filing_year",
        COUNT(DISTINCT cpc_applications."publication_number") AS "applications_in_year"
    FROM
        cpc_applications
    INNER JOIN
        top_assignees ON cpc_applications."assignee_name" = top_assignees."assignee_name"
    GROUP BY
        cpc_applications."assignee_name",
        cpc_applications."filing_year"
),
max_year_per_assignee AS (
    SELECT
        "assignee_name",
        "filing_year",
        "applications_in_year",
        RANK() OVER (
            PARTITION BY "assignee_name"
            ORDER BY "applications_in_year" DESC NULLS LAST,
                     "filing_year"
        ) AS rank
    FROM
        assignee_years
),
top_year_per_assignee AS (
    SELECT
        "assignee_name",
        "filing_year",
        "applications_in_year" AS "number_of_applications_in_that_year"
    FROM
        max_year_per_assignee
    WHERE
        rank = 1
),
country_counts AS (
    SELECT
        cpc_applications."assignee_name",
        cpc_applications."filing_year",
        cpc_applications."country_code",
        COUNT(DISTINCT cpc_applications."publication_number") AS "application_count"
    FROM
        cpc_applications
    INNER JOIN
        top_year_per_assignee ON cpc_applications."assignee_name" = top_year_per_assignee."assignee_name"
                              AND cpc_applications."filing_year" = top_year_per_assignee."filing_year"
    GROUP BY
        cpc_applications."assignee_name",
        cpc_applications."filing_year",
        cpc_applications."country_code"
),
max_country_per_assignee AS (
    SELECT
        "assignee_name",
        "filing_year",
        "country_code",
        "application_count",
        RANK() OVER (
            PARTITION BY "assignee_name", "filing_year"
            ORDER BY "application_count" DESC NULLS LAST,
                     "country_code"
        ) AS rank
    FROM
        country_counts
),
top_country_per_assignee AS (
    SELECT
        "assignee_name",
        "filing_year",
        "country_code" AS "country_code_with_most_applications_during_that_year"
    FROM
        max_country_per_assignee
    WHERE
        rank = 1
)
SELECT
    ta."assignee_name" AS "name_of_assignee",
    ta."total_number_of_applications",
    tyy."filing_year" AS "year_with_most_applications",
    tyy."number_of_applications_in_that_year",
    tcpa."country_code_with_most_applications_during_that_year"
FROM
    top_assignees ta
INNER JOIN
    top_year_per_assignee tyy ON ta."assignee_name" = tyy."assignee_name"
INNER JOIN
    top_country_per_assignee tcpa ON tyy."assignee_name" = tcpa."assignee_name"
                                 AND tyy."filing_year" = tcpa."filing_year"
ORDER BY
    ta."total_number_of_applications" DESC NULLS LAST,
    ta."assignee_name";