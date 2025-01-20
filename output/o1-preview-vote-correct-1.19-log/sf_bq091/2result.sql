WITH patents_data AS (
    SELECT
        f_assignee.value::STRING AS assignee_name,
        f_cpc.value:"code"::STRING AS cpc_code,
        EXTRACT(year FROM TRY_TO_DATE("filing_date"::VARCHAR, 'YYYYMMDD')) AS filing_year
    FROM
        PATENTS.PATENTS.PUBLICATIONS,
        LATERAL FLATTEN(input => "assignee") f_assignee,
        LATERAL FLATTEN(input => "cpc") f_cpc
    WHERE
        f_cpc.value:"code"::STRING LIKE 'A61%'
        AND TRY_TO_DATE("filing_date"::VARCHAR, 'YYYYMMDD') IS NOT NULL
),
assignee_counts AS (
    SELECT
        assignee_name,
        COUNT(*) AS application_count
    FROM
        patents_data
    GROUP BY
        assignee_name
),
top_assignee AS (
    SELECT
        assignee_name
    FROM
        assignee_counts
    ORDER BY
        application_count DESC NULLS LAST
    LIMIT 1
),
filings_per_year AS (
    SELECT
        pd.filing_year,
        COUNT(*) AS applications_in_year
    FROM
        patents_data pd
        JOIN top_assignee ta ON pd.assignee_name = ta.assignee_name
    GROUP BY
        pd.filing_year
)
SELECT
    filings_per_year.filing_year AS "Year"
FROM
    filings_per_year
ORDER BY
    applications_in_year DESC NULLS LAST
LIMIT 1;