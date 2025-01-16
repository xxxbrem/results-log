WITH "patent_data" AS (
    SELECT
        CASE
            WHEN IS_OBJECT(a.value) AND a.value:"name" IS NOT NULL THEN a.value:"name"::STRING
            WHEN NOT IS_OBJECT(a.value) THEN a.value::STRING
            ELSE NULL
        END AS "assignee_name",
        t."country_code" AS "country_code",
        TO_NUMBER(SUBSTRING(TO_VARCHAR(t."filing_date"), 1, 4)) AS "filing_year"
    FROM
        "PATENTS"."PATENTS"."PUBLICATIONS" t
    CROSS JOIN LATERAL FLATTEN(input => t."assignee") a
    CROSS JOIN LATERAL FLATTEN(input => t."cpc") c
    WHERE
        (
            (IS_OBJECT(c.value) AND c.value:"code"::STRING LIKE 'A01B3%')
            OR (NOT IS_OBJECT(c.value) AND c.value::STRING LIKE 'A01B3%')
        )
        AND t."filing_date" IS NOT NULL
        AND (
            (IS_OBJECT(a.value) AND a.value:"name" IS NOT NULL)
            OR (NOT IS_OBJECT(a.value) AND a.value IS NOT NULL)
        )
),
"assignee_total_applications" AS (
    SELECT
        "assignee_name",
        COUNT(*) AS "total_applications"
    FROM "patent_data"
    GROUP BY "assignee_name"
),
"assignee_year_applications" AS (
    SELECT
        "assignee_name",
        "filing_year",
        COUNT(*) AS "applications_in_year",
        ROW_NUMBER() OVER (PARTITION BY "assignee_name" ORDER BY COUNT(*) DESC NULLS LAST) AS "rn"
    FROM "patent_data"
    GROUP BY "assignee_name", "filing_year"
),
"assignee_top_year" AS (
    SELECT
        "assignee_name",
        "filing_year" AS "year_with_most_applications",
        "applications_in_year"
    FROM "assignee_year_applications"
    WHERE "rn" = 1
),
"assignee_country_applications" AS (
    SELECT
        "assignee_name",
        "filing_year",
        "country_code",
        COUNT(*) AS "applications_in_country",
        ROW_NUMBER() OVER (PARTITION BY "assignee_name", "filing_year" ORDER BY COUNT(*) DESC NULLS LAST) AS "rn"
    FROM "patent_data"
    GROUP BY "assignee_name", "filing_year", "country_code"
),
"assignee_top_country" AS (
    SELECT
        "assignee_name",
        "filing_year",
        "country_code" AS "country_code_with_most_applications_during_that_year"
    FROM "assignee_country_applications"
    WHERE "rn" = 1
)
SELECT
    ata."assignee_name",
    ata."total_applications",
    aty."year_with_most_applications",
    aty."applications_in_year" AS "applications_in_that_year",
    atc."country_code_with_most_applications_during_that_year"
FROM
    "assignee_total_applications" ata
JOIN "assignee_top_year" aty ON ata."assignee_name" = aty."assignee_name"
LEFT JOIN "assignee_top_country" atc ON ata."assignee_name" = atc."assignee_name" AND aty."year_with_most_applications" = atc."filing_year"
WHERE ata."assignee_name" IS NOT NULL
ORDER BY ata."total_applications" DESC NULLS LAST
LIMIT 3
;