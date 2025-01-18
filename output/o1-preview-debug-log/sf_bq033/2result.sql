WITH months AS (
  SELECT
    YEAR(DATEADD(month, seq4(), '2008-01-01')) AS "Year",
    MONTHNAME(DATEADD(month, seq4(), '2008-01-01')) AS "Month",
    MONTH(DATEADD(month, seq4(), '2008-01-01')) AS "Month_Number"
  FROM TABLE(generator(rowcount => ((2022 - 2008 + 1) * 12)))
  WHERE DATEADD(month, seq4(), '2008-01-01') <= '2022-12-01'
)
SELECT
  m."Year",
  m."Month",
  COALESCE(c."Number_of_Filings", 0) AS "Number_of_Filings"
FROM
  months m
LEFT JOIN (
  SELECT
    YEAR(TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD')) AS "Year",
    MONTHNAME(TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD')) AS "Month",
    COUNT(DISTINCT t."publication_number") AS "Number_of_Filings"
  FROM
    PATENTS.PATENTS.PUBLICATIONS t,
    LATERAL FLATTEN(input => t."abstract_localized") f
  WHERE
    t."country_code" = 'US' AND
    t."filing_date" BETWEEN 20080101 AND 20221231 AND
    LOWER(f.VALUE:"text"::STRING) LIKE '%internet of things%'
  GROUP BY
    1, 2
) c ON m."Year" = c."Year" AND m."Month" = c."Month"
ORDER BY
  m."Year", m."Month_Number";