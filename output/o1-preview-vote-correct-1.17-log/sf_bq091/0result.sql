WITH top_assignee_name AS (
    SELECT f1.value:"name"::STRING AS assignee_name
    FROM PATENTS.PATENTS.PUBLICATIONS t,
         LATERAL FLATTEN(input => t."assignee_harmonized") f1,
         LATERAL FLATTEN(input => t."cpc") f2
    WHERE f2.value:"code"::STRING LIKE 'A61%'
    GROUP BY assignee_name
    ORDER BY COUNT(DISTINCT t."application_number") DESC NULLS LAST
    LIMIT 1
)
SELECT SUBSTRING(t."filing_date"::STRING, 1, 4) AS "year",
       COUNT(DISTINCT t."application_number") AS "number_of_applications"
FROM PATENTS.PATENTS.PUBLICATIONS t,
     LATERAL FLATTEN(input => t."assignee_harmonized") f1,
     LATERAL FLATTEN(input => t."cpc") f2
WHERE f1.value:"name"::STRING = (SELECT assignee_name FROM top_assignee_name)
  AND f2.value:"code"::STRING LIKE 'A61%'
GROUP BY "year"
ORDER BY "number_of_applications" DESC NULLS LAST
LIMIT 1;