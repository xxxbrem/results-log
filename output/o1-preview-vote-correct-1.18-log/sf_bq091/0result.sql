WITH data AS (
    SELECT
        f_assignee.value:"name"::STRING AS "Assignee",
        SUBSTRING(t."filing_date"::VARCHAR, 1, 4) AS "Year"
    FROM PATENTS.PATENTS.PUBLICATIONS t,
         TABLE(FLATTEN(input => t."assignee_harmonized")) AS f_assignee
    WHERE
        t."filing_date" IS NOT NULL
        AND f_assignee.value:"name"::STRING IS NOT NULL
),
assignee_totals AS (
    SELECT
        "Assignee",
        COUNT(*) AS "Total_Applications"
    FROM data
    GROUP BY "Assignee"
    ORDER BY "Total_Applications" DESC NULLS LAST
    LIMIT 1
),
assignee_year_counts AS (
    SELECT
        "Assignee",
        "Year",
        COUNT(*) AS "Number_of_Applications"
    FROM data
    WHERE "Assignee" = (SELECT "Assignee" FROM assignee_totals)
    GROUP BY "Assignee", "Year"
    ORDER BY "Number_of_Applications" DESC NULLS LAST
    LIMIT 1
)
SELECT
    "Assignee", "Year", "Number_of_Applications"
FROM assignee_year_counts;