WITH base_data AS (
    SELECT
        f_assignee.value:"name"::STRING AS "assignee_name",
        t."publication_date",
        t."country_code",
        TO_CHAR(TO_DATE(t."publication_date"::VARCHAR, 'YYYYMMDD'), 'YYYY') AS "publication_year"
    FROM
        PATENTS.PATENTS.PUBLICATIONS t
        , LATERAL FLATTEN(input => t."cpc") f_cpc
        , LATERAL FLATTEN(input => t."assignee_harmonized") f_assignee
    WHERE
        f_cpc.value:"code"::STRING LIKE 'A01B3%'
        AND f_assignee.value:"name" IS NOT NULL
        AND t."publication_date" IS NOT NULL
        AND t."country_code" IS NOT NULL
        AND TRY_TO_DATE(t."publication_date"::VARCHAR, 'YYYYMMDD') IS NOT NULL
)
, total_applications_per_assignee AS (
    SELECT
        "assignee_name",
        COUNT(*) AS "total_applications"
    FROM base_data
    GROUP BY "assignee_name"
)
, applications_per_year AS (
    SELECT
        "assignee_name",
        "publication_year",
        COUNT(*) AS "applications_in_year"
    FROM base_data
    GROUP BY "assignee_name", "publication_year"
)
, year_with_most_applications AS (
    SELECT
        "assignee_name",
        "publication_year" AS "year_with_most_applications",
        "applications_in_year",
        ROW_NUMBER() OVER(PARTITION BY "assignee_name" ORDER BY "applications_in_year" DESC NULLS LAST) AS "rn_year"
    FROM applications_per_year
)
, country_applications AS (
    SELECT
        bd."assignee_name",
        bd."publication_year",
        bd."country_code",
        COUNT(*) AS "applications_in_country"
    FROM base_data bd
    JOIN (SELECT * FROM year_with_most_applications WHERE "rn_year" = 1) y
        ON bd."assignee_name" = y."assignee_name" AND bd."publication_year" = y."year_with_most_applications"
    GROUP BY bd."assignee_name", bd."publication_year", bd."country_code"
)
, country_with_most_applications AS (
    SELECT
        ca."assignee_name",
        ca."publication_year",
        ca."country_code" AS "country_code_with_most_applications_during_that_year",
        ca."applications_in_country",
        ROW_NUMBER() OVER(PARTITION BY ca."assignee_name", ca."publication_year" ORDER BY ca."applications_in_country" DESC NULLS LAST) AS "rn_country"
    FROM country_applications ca
)
SELECT
    t."assignee_name",
    t."total_applications",
    y."year_with_most_applications",
    y."applications_in_year" AS "applications_in_that_year",
    c."country_code_with_most_applications_during_that_year"
FROM
    total_applications_per_assignee t
JOIN
    (SELECT * FROM year_with_most_applications WHERE "rn_year" = 1) y
    ON t."assignee_name" = y."assignee_name"
JOIN
    (SELECT * FROM country_with_most_applications WHERE "rn_country" = 1) c
    ON t."assignee_name" = c."assignee_name" AND y."year_with_most_applications" = c."publication_year"
ORDER BY t."total_applications" DESC NULLS LAST
LIMIT 3;