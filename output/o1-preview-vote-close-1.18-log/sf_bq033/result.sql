WITH months AS (
    SELECT
        DATE_TRUNC('MONTH', DATEADD(MONTH, seq4(), '2008-01-01')) AS "month_date"
    FROM TABLE(GENERATOR(ROWCOUNT => 180))
    WHERE DATEADD(MONTH, seq4(), '2008-01-01') <= '2022-12-31'
),
filings AS (
    SELECT
        DATE_TRUNC('MONTH', TRY_TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD')) AS "filing_month",
        COUNT(DISTINCT t."publication_number") AS "Num_filings"
    FROM
        PATENTS.PATENTS.PUBLICATIONS t,
        LATERAL FLATTEN(input => t."abstract_localized") abstract_element
    WHERE
        t."country_code" = 'US'
        AND abstract_element.value:"language"::STRING = 'en'
        AND abstract_element.value:"text"::STRING ILIKE '%internet of things%'
        AND TRY_TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD') BETWEEN '2008-01-01' AND '2022-12-31'
        AND TRY_TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD') IS NOT NULL
    GROUP BY 1
)
SELECT
    EXTRACT(YEAR FROM m."month_date") AS "Year",
    EXTRACT(MONTH FROM m."month_date") AS "Month",
    COALESCE(f."Num_filings", 0) AS "Num_filings"
FROM
    months m
LEFT JOIN
    filings f
ON m."month_date" = f."filing_month"
ORDER BY
    m."month_date";