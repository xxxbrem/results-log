WITH months AS (
  SELECT
    YEAR(date_column) AS "Year",
    MONTH(date_column) AS "Month_num",
    TO_CHAR(date_column, 'Mon') AS "Month"
  FROM (
    SELECT DATEADD(
             month, 
             ROW_NUMBER() OVER (ORDER BY NULL) - 1, 
             '2008-01-01'::DATE
           ) AS date_column
    FROM TABLE(GENERATOR(ROWCOUNT => 180))
  )
  WHERE date_column BETWEEN '2008-01-01' AND '2022-12-31'
)
SELECT
  m."Year",
  m."Month_num",
  m."Month",
  COALESCE(f."Number_of_filings", 0) AS "Number_of_filings"
FROM months m
LEFT JOIN (
  SELECT
    YEAR(fd."filing_date") AS "Year",
    MONTH(fd."filing_date") AS "Month_num",
    COUNT(DISTINCT fd."publication_number") AS "Number_of_filings"
  FROM (
    SELECT
      t."publication_number",
      TRY_TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD') AS "filing_date",
      LOWER(f.VALUE:"text"::STRING) AS "abstract_text"
    FROM PATENTS.PATENTS.PUBLICATIONS t,
         LATERAL FLATTEN(input => t."abstract_localized") f
    WHERE t."country_code" = 'US'
      AND t."filing_date" IS NOT NULL
      AND t."filing_date" <> 0
      AND TRY_TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD') BETWEEN '2008-01-01' AND '2022-12-31'
      AND f.VALUE:"text" IS NOT NULL
  ) fd
  WHERE fd."abstract_text" LIKE '%internet of things%'
  GROUP BY 1, 2
) f
ON m."Year" = f."Year" AND m."Month_num" = f."Month_num"
ORDER BY m."Year", m."Month_num";