WITH cpc_assignee_data AS (
    SELECT
        t."publication_number",
        CASE 
            WHEN LENGTH(t."publication_date"::VARCHAR) >= 8 THEN
                TO_NUMBER(SUBSTR(t."publication_date"::VARCHAR, 1, 4)) 
            ELSE NULL 
        END AS "pub_year",
        t."country_code",
        f_cpc.value:"code"::STRING AS "cpc_code",
        CASE 
            WHEN TYPEOF(f_assignee.value) = 'OBJECT' THEN f_assignee.value:"name"::STRING
            ELSE f_assignee.value::STRING
        END AS "assignee_name"
    FROM 
        "PATENTS"."PATENTS"."PUBLICATIONS" t,
        LATERAL FLATTEN(input => t."cpc") AS f_cpc,
        LATERAL FLATTEN(input => t."assignee") AS f_assignee
    WHERE 
        f_cpc.value:"code"::STRING LIKE 'A01B3%'
        AND (
            CASE 
                WHEN TYPEOF(f_assignee.value) = 'OBJECT' THEN f_assignee.value:"name"::STRING
                ELSE f_assignee.value::STRING
            END
        ) IS NOT NULL
        AND t."publication_date" IS NOT NULL
),
top_assignees AS (
    SELECT
        "assignee_name",
        COUNT(DISTINCT "publication_number") AS "total_applications"
    FROM
        cpc_assignee_data
    GROUP BY
        "assignee_name"
    ORDER BY
        "total_applications" DESC NULLS LAST
    LIMIT 3
),
assignee_peak_years AS (
    SELECT
        "assignee_name",
        "pub_year",
        COUNT(DISTINCT "publication_number") AS "applications_in_year",
        ROW_NUMBER() OVER (
            PARTITION BY "assignee_name" 
            ORDER BY COUNT(DISTINCT "publication_number") DESC NULLS LAST, "pub_year" ASC
        ) AS rn
    FROM
        cpc_assignee_data
    WHERE
        "assignee_name" IN (SELECT "assignee_name" FROM top_assignees)
        AND "pub_year" IS NOT NULL
    GROUP BY
        "assignee_name", "pub_year"
),
assignee_peak_year AS (
    SELECT
        "assignee_name",
        "pub_year" AS "peak_year",
        "applications_in_year"
    FROM
        assignee_peak_years
    WHERE
        rn = 1
),
assignee_top_country AS (
    SELECT
        apy."assignee_name",
        apy."peak_year",
        cd."country_code",
        COUNT(DISTINCT cd."publication_number") AS "applications_in_country",
        ROW_NUMBER() OVER (
            PARTITION BY apy."assignee_name", apy."peak_year" 
            ORDER BY COUNT(DISTINCT cd."publication_number") DESC NULLS LAST
        ) AS rn
    FROM
        cpc_assignee_data cd
        INNER JOIN assignee_peak_year apy 
            ON cd."assignee_name" = apy."assignee_name" 
            AND cd."pub_year" = apy."peak_year"
    WHERE
        cd."country_code" IS NOT NULL
    GROUP BY
        apy."assignee_name", apy."peak_year", cd."country_code"
),
assignee_top_country_code AS (
    SELECT
        "assignee_name",
        "peak_year",
        "country_code" AS "top_country_code"
    FROM
        assignee_top_country
    WHERE 
        rn = 1
)
SELECT
    ta."assignee_name",
    ta."total_applications",
    apy."peak_year",
    apy."applications_in_year" AS "applications_in_peak_year",
    atc."top_country_code"
FROM
    top_assignees ta
    INNER JOIN assignee_peak_year apy 
        ON ta."assignee_name" = apy."assignee_name"
    INNER JOIN assignee_top_country_code atc 
        ON ta."assignee_name" = atc."assignee_name" 
        AND apy."peak_year" = atc."peak_year"
ORDER BY
    ta."total_applications" DESC NULLS LAST;