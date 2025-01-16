WITH top_assignee AS (
    SELECT assignee_f.value:"name"::STRING AS "assignee_name",
           COUNT(DISTINCT t."application_number") AS "application_count"
    FROM PATENTS.PATENTS.PUBLICATIONS t,
         LATERAL FLATTEN(input => t."assignee_harmonized") assignee_f,
         LATERAL FLATTEN(input => t."cpc") cpc_f
    WHERE cpc_f.value:"code"::STRING LIKE 'A61%'
    GROUP BY assignee_f.value:"name"::STRING
    ORDER BY "application_count" DESC NULLS LAST
    LIMIT 1
),
filings_by_year AS (
    SELECT assignee_f.value:"name"::STRING AS "assignee_name",
           YEAR(TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD')) AS "year",
           COUNT(DISTINCT t."application_number") AS "number_of_filings"
    FROM PATENTS.PATENTS.PUBLICATIONS t,
         LATERAL FLATTEN(input => t."assignee_harmonized") assignee_f,
         LATERAL FLATTEN(input => t."cpc") cpc_f
    WHERE cpc_f.value:"code"::STRING LIKE 'A61%'
      AND assignee_f.value:"name"::STRING = (SELECT "assignee_name" FROM top_assignee)
      AND TRY_TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD') IS NOT NULL
    GROUP BY assignee_f.value:"name"::STRING, "year"
)
SELECT "assignee_name", "year", "number_of_filings"
FROM filings_by_year
ORDER BY "number_of_filings" DESC NULLS LAST
LIMIT 1;