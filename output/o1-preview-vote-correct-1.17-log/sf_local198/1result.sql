WITH CountriesWithMoreThan4Customers AS (
  SELECT "Country"
  FROM "CHINOOK"."CHINOOK"."CUSTOMERS"
  GROUP BY "Country"
  HAVING COUNT(*) > 4
)
SELECT ROUND(MEDIAN(total_sales), 4) AS median_total_sales
FROM (
  SELECT C."Country", SUM(I."Total") AS total_sales
  FROM "CHINOOK"."CHINOOK"."CUSTOMERS" C
  JOIN "CHINOOK"."CHINOOK"."INVOICES" I ON C."CustomerId" = I."CustomerId"
  WHERE C."Country" IN (SELECT "Country" FROM CountriesWithMoreThan4Customers)
  GROUP BY C."Country"
)