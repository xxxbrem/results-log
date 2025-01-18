WITH months AS (
  SELECT
    DATEADD(month, seq4(), '2008-01-01') AS "month_start"
  FROM TABLE(GENERATOR(ROWCOUNT => ((2022 - 2008 + 1) * 12)))
  WHERE DATEADD(month, seq4(), '2008-01-01') <= '2022-12-01'
),
filings AS (
  -- Handle records where 'abstract_localized' is an object
  SELECT
    DATE_TRUNC('month', TRY_TO_DATE("filing_date"::VARCHAR, 'YYYYMMDD')) AS "Filing_Month",
    COUNT(DISTINCT "application_number") AS "Number_of_Filings"
  FROM PATENTS.PATENTS.PUBLICATIONS
  WHERE "country_code" = 'US'
    AND TRY_TO_DATE("filing_date"::VARCHAR, 'YYYYMMDD') BETWEEN '2008-01-01' AND '2022-12-31'
    AND IS_OBJECT("abstract_localized")
    AND "abstract_localized":"text"::STRING ILIKE '%internet of things%'
  GROUP BY "Filing_Month"

  UNION ALL

  -- Handle records where 'abstract_localized' is an array
  SELECT
    DATE_TRUNC('month', TRY_TO_DATE("filing_date"::VARCHAR, 'YYYYMMDD')) AS "Filing_Month",
    COUNT(DISTINCT "application_number") AS "Number_of_Filings"
  FROM PATENTS.PATENTS.PUBLICATIONS,
    LATERAL FLATTEN(INPUT => "abstract_localized") f
  WHERE "country_code" = 'US'
    AND TRY_TO_DATE("filing_date"::VARCHAR, 'YYYYMMDD') BETWEEN '2008-01-01' AND '2022-12-31'
    AND IS_ARRAY("abstract_localized")
    AND f.value:"text"::STRING ILIKE '%internet of things%'
  GROUP BY "Filing_Month"
),
monthly_filings AS (
  SELECT
    "Filing_Month",
    SUM("Number_of_Filings") AS "Number_of_Filings"
  FROM filings
  GROUP BY "Filing_Month"
)
SELECT
  YEAR(m."month_start") AS "Year",
  MONTHNAME(m."month_start") AS "Month",
  COALESCE(f."Number_of_Filings", 0) AS "Number_of_Filings"
FROM months m
LEFT JOIN monthly_filings f ON m."month_start" = f."Filing_Month"
ORDER BY m."month_start";