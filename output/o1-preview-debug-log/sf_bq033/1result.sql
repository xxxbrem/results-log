WITH months AS (
  SELECT DATE_TRUNC('month', DATEADD('month', ROW_NUMBER() OVER (ORDER BY NULL) - 1, '2008-01-01')) AS month_start
  FROM TABLE(GENERATOR(ROWCOUNT => 180))
),
filing_counts AS (
  SELECT
    DATE_TRUNC('month', TRY_TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD')) AS month_start,
    COUNT(DISTINCT t."publication_number") AS filings_count
  FROM PATENTS.PATENTS.PUBLICATIONS t,
       LATERAL FLATTEN(input => t."abstract_localized") f
  WHERE
    t."country_code" = 'US'
    AND t."filing_date" BETWEEN 20080101 AND 20221231
    AND TRY_TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD') IS NOT NULL
    AND f.VALUE:"text"::STRING ILIKE '%internet of things%'
  GROUP BY month_start
)
SELECT
  EXTRACT(YEAR FROM m.month_start) AS "Year",
  LPAD(EXTRACT(MONTH FROM m.month_start)::VARCHAR, 2, '0') AS "Month_num",
  TO_CHAR(m.month_start, 'Mon') AS "Month",
  COALESCE(c.filings_count, 0) AS "Number_of_filings"
FROM months m
LEFT JOIN filing_counts c ON m.month_start = c.month_start
ORDER BY m.month_start;