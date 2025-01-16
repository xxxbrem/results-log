WITH base_data AS (
    SELECT
        a.value::VARIANT:"name"::STRING AS "assignee_name",
        TO_CHAR(TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD'), 'YYYY') AS "filing_year",
        t."application_number" AS "application_number",
        t."country_code" AS "country_code"
    FROM
        PATENTS.PATENTS.PUBLICATIONS t,
        LATERAL FLATTEN(input => t."cpc") c,
        LATERAL FLATTEN(input => t."assignee_harmonized") a
    WHERE
        SUBSTRING(c.value::VARIANT:"code"::STRING, 1, 5) = 'A01B3'
        AND TRY_TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD') IS NOT NULL
        AND a.value::VARIANT:"name"::STRING IS NOT NULL
),
total_apps_per_assignee AS (
    SELECT
        "assignee_name",
        COUNT(DISTINCT "application_number") AS "total_number_of_applications"
    FROM
        base_data
    GROUP BY
        "assignee_name"
),
top_3_assignees AS (
    SELECT
        "assignee_name",
        "total_number_of_applications"
    FROM (
        SELECT
            "assignee_name",
            "total_number_of_applications",
            ROW_NUMBER() OVER (ORDER BY "total_number_of_applications" DESC NULLS LAST) AS rn
        FROM
            total_apps_per_assignee
    )
    WHERE
        rn <= 3
),
apps_per_assignee_year AS (
    SELECT
        "assignee_name",
        "filing_year",
        COUNT(DISTINCT "application_number") AS "number_of_applications_in_that_year"
    FROM
        base_data
    WHERE
        "assignee_name" IN (SELECT "assignee_name" FROM top_3_assignees)
    GROUP BY
        "assignee_name", "filing_year"
),
top_year_per_assignee AS (
    SELECT
        "assignee_name",
        "filing_year" AS "year_with_most_applications",
        "number_of_applications_in_that_year"
    FROM (
        SELECT
            "assignee_name",
            "filing_year",
            "number_of_applications_in_that_year",
            ROW_NUMBER() OVER (PARTITION BY "assignee_name" ORDER BY "number_of_applications_in_that_year" DESC NULLS LAST, "filing_year") AS rn
        FROM
            apps_per_assignee_year
    )
    WHERE
        rn = 1
),
data_for_top_years AS (
    SELECT
        bd."assignee_name",
        bd."filing_year",
        bd."country_code",
        bd."application_number"
    FROM
        base_data bd
        INNER JOIN top_year_per_assignee ty
            ON bd."assignee_name" = ty."assignee_name"
            AND bd."filing_year" = ty."year_with_most_applications"
),
apps_per_country_code AS (
    SELECT
        "assignee_name",
        "country_code",
        COUNT(DISTINCT "application_number") AS "applications_in_country"
    FROM
        data_for_top_years
    GROUP BY
        "assignee_name", "country_code"
),
top_country_per_assignee AS (
    SELECT
        "assignee_name",
        "country_code" AS "country_code_with_most_applications_in_that_year"
    FROM (
        SELECT
            "assignee_name",
            "country_code",
            ROW_NUMBER() OVER (PARTITION BY "assignee_name" ORDER BY "applications_in_country" DESC NULLS LAST) AS rn
        FROM
            apps_per_country_code
    )
    WHERE
        rn = 1
)
SELECT
    t3a."assignee_name",
    t3a."total_number_of_applications",
    typa."year_with_most_applications",
    typa."number_of_applications_in_that_year",
    tcpa."country_code_with_most_applications_in_that_year"
FROM
    top_3_assignees t3a
    INNER JOIN top_year_per_assignee typa ON t3a."assignee_name" = typa."assignee_name"
    INNER JOIN top_country_per_assignee tcpa ON t3a."assignee_name" = tcpa."assignee_name"
ORDER BY
    t3a."total_number_of_applications" DESC NULLS LAST;