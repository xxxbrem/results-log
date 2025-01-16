WITH cpc_filtered AS (
    SELECT
        t."publication_number",
        t."filing_date",
        t."country_code",
        t."assignee_harmonized"
    FROM
        "PATENTS"."PATENTS"."PUBLICATIONS" t,
        LATERAL FLATTEN(input => t."cpc") f
    WHERE
        LEFT(f.value:"code"::STRING, 5) = 'A01B3'
),
assignees AS (
    SELECT
        c."publication_number",
        c."filing_date",
        c."country_code",
        h.value:"name"::STRING AS "assignee_name"
    FROM
        cpc_filtered c,
        LATERAL FLATTEN(input => c."assignee_harmonized") h
),
top_assignees AS (
    SELECT
        "assignee_name",
        COUNT(DISTINCT "publication_number") AS "total_applications"
    FROM
        assignees
    GROUP BY
        "assignee_name"
    ORDER BY
        "total_applications" DESC NULLS LAST
    LIMIT 3
),
assignee_year_counts AS (
    SELECT
        a."assignee_name",
        EXTRACT(year FROM CASE
            WHEN a."filing_date" >= 1e15 THEN TO_TIMESTAMP_NTZ(a."filing_date" / 1000000)
            WHEN a."filing_date" >= 1e12 THEN TO_TIMESTAMP_NTZ(a."filing_date" / 1000)
            ELSE TO_TIMESTAMP_NTZ(a."filing_date")
        END) AS "filing_year",
        COUNT(DISTINCT a."publication_number") AS "applications_in_that_year"
    FROM
        assignees a
    WHERE
        a."assignee_name" IN (SELECT "assignee_name" FROM top_assignees)
        AND a."filing_date" IS NOT NULL
        AND a."filing_date" > 0
    GROUP BY
        a."assignee_name",
        EXTRACT(year FROM CASE
            WHEN a."filing_date" >= 1e15 THEN TO_TIMESTAMP_NTZ(a."filing_date" / 1000000)
            WHEN a."filing_date" >= 1e12 THEN TO_TIMESTAMP_NTZ(a."filing_date" / 1000)
            ELSE TO_TIMESTAMP_NTZ(a."filing_date")
        END)
),
assignee_max_year AS (
    SELECT
        ayc."assignee_name",
        ayc."filing_year",
        ayc."applications_in_that_year",
        ROW_NUMBER() OVER (PARTITION BY ayc."assignee_name" ORDER BY ayc."applications_in_that_year" DESC, ayc."filing_year" DESC NULLS LAST) AS rn
    FROM
        assignee_year_counts ayc
),
assignee_year_country_counts AS (
    SELECT
        a."assignee_name",
        EXTRACT(year FROM CASE
            WHEN a."filing_date" >= 1e15 THEN TO_TIMESTAMP_NTZ(a."filing_date" / 1000000)
            WHEN a."filing_date" >= 1e12 THEN TO_TIMESTAMP_NTZ(a."filing_date" / 1000)
            ELSE TO_TIMESTAMP_NTZ(a."filing_date")
        END) AS "filing_year",
        a."country_code",
        COUNT(DISTINCT a."publication_number") AS "applications_in_year_country"
    FROM
        assignees a
    WHERE
        a."assignee_name" IN (SELECT "assignee_name" FROM top_assignees)
        AND a."filing_date" IS NOT NULL
        AND a."filing_date" > 0
        AND a."country_code" IS NOT NULL
        AND a."country_code" != ''
    GROUP BY
        a."assignee_name",
        EXTRACT(year FROM CASE
            WHEN a."filing_date" >= 1e15 THEN TO_TIMESTAMP_NTZ(a."filing_date" / 1000000)
            WHEN a."filing_date" >= 1e12 THEN TO_TIMESTAMP_NTZ(a."filing_date" / 1000)
            ELSE TO_TIMESTAMP_NTZ(a."filing_date")
        END),
        a."country_code"
),
assignee_top_country AS (
    SELECT
        aycc."assignee_name",
        aycc."filing_year",
        aycc."country_code" AS "top_country_code",
        aycc."applications_in_year_country",
        ROW_NUMBER() OVER (PARTITION BY aycc."assignee_name", aycc."filing_year" ORDER BY aycc."applications_in_year_country" DESC NULLS LAST) AS rn
    FROM
        assignee_year_country_counts aycc
),
assignee_final AS (
    SELECT
        am."assignee_name",
        am."filing_year",
        am."applications_in_that_year",
        atc."top_country_code"
    FROM
        assignee_max_year am
    JOIN
        assignee_top_country atc ON am."assignee_name" = atc."assignee_name" AND am."filing_year" = atc."filing_year" AND atc.rn = 1
    WHERE
        am.rn = 1
),
final_result AS (
    SELECT
        ta."assignee_name",
        ta."total_applications",
        af."filing_year" AS "year_with_most_applications",
        af."applications_in_that_year",
        af."top_country_code"
    FROM
        top_assignees ta
    JOIN
        assignee_final af ON ta."assignee_name" = af."assignee_name"
    ORDER BY
        ta."total_applications" DESC NULLS LAST
)
SELECT
    "assignee_name",
    "total_applications",
    "year_with_most_applications",
    "applications_in_that_year",
    "top_country_code"
FROM
    final_result;