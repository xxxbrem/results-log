WITH CountryStats AS (
  SELECT
    c."Country",
    COUNT(DISTINCT c."CustomerId") AS "CustomerCount",
    SUM(i."Total") AS "CountryTotalSales"
  FROM
    CHINOOK.CHINOOK."CUSTOMERS" c
    JOIN CHINOOK.CHINOOK."INVOICES" i ON c."CustomerId" = i."CustomerId"
  GROUP BY
    c."Country"
),
EligibleCountries AS (
  SELECT "Country", "CountryTotalSales"
  FROM CountryStats
  WHERE "CustomerCount" > 4
)
SELECT
  MEDIAN("CountryTotalSales") AS "amount"
FROM EligibleCountries;