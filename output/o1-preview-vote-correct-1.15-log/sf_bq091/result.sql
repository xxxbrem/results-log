WITH cte AS (
    SELECT
        COALESCE(f_assignee.value:"name"::STRING, f_assignee.value:"organization"::STRING) AS "assignee_name",
        SUBSTRING(TO_VARCHAR(p."filing_date"), 1, 4) AS "filing_year",
        p."application_number" AS "application_number"
    FROM
        PATENTS.PATENTS.PUBLICATIONS p,
        LATERAL FLATTEN(INPUT => p."assignee_harmonized") f_assignee,
        LATERAL FLATTEN(INPUT => p."cpc") f_cpc
    WHERE
        f_cpc.value:"code"::STRING LIKE 'A61%'
        AND COALESCE(f_assignee.value:"name"::STRING, f_assignee.value:"organization"::STRING) IS NOT NULL
        AND p."filing_date" > 0
),
top_assignee AS (
    SELECT
        "assignee_name",
        COUNT(DISTINCT "application_number") AS "total_applications"
    FROM
        cte
    GROUP BY
        "assignee_name"
    ORDER BY
        "total_applications" DESC NULLS LAST
    LIMIT 1
)
SELECT
    cte."assignee_name" AS "assignee_name",
    cte."filing_year" AS "year",
    COUNT(DISTINCT cte."application_number") AS "application_count"
FROM
    cte
    JOIN top_assignee ON cte."assignee_name" = top_assignee."assignee_name"
GROUP BY
    cte."assignee_name", cte."filing_year"
ORDER BY
    "application_count" DESC NULLS LAST
LIMIT 1;