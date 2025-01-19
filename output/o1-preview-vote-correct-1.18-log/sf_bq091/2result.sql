WITH ipc_a61_applications AS (
  SELECT DISTINCT t."application_number"
  FROM PATENTS.PATENTS.PUBLICATIONS t,
  LATERAL FLATTEN(input => t."ipc") f
  WHERE f.value:"code"::STRING LIKE 'A61%'
),
assignee_applications AS (
  SELECT ia."application_number", ah.value:"name"::STRING AS "assignee_name", t."filing_date"
  FROM ipc_a61_applications ia
  JOIN PATENTS.PATENTS.PUBLICATIONS t ON ia."application_number" = t."application_number"
  , LATERAL FLATTEN(input => t."assignee_harmonized") ah
),
assignee_counts AS (
  SELECT "assignee_name", COUNT(DISTINCT "application_number") AS "application_count"
  FROM assignee_applications
  GROUP BY "assignee_name"
  ORDER BY "application_count" DESC
  LIMIT 1
),
top_assignee_applications AS (
  SELECT aa.*
  FROM assignee_applications aa
  JOIN assignee_counts ac ON aa."assignee_name" = ac."assignee_name"
)
SELECT YEAR(TRY_TO_DATE(CAST("filing_date" AS VARCHAR), 'YYYYMMDD')) AS "Year",
       COUNT(DISTINCT "application_number") AS "Number_of_Applications"
FROM top_assignee_applications
WHERE "filing_date" IS NOT NULL
GROUP BY "Year"
ORDER BY "Number_of_Applications" DESC NULLS LAST
LIMIT 1;