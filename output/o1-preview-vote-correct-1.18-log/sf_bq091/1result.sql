WITH a61_patents AS (
  SELECT
    t."publication_number",
    assignee.value::STRING AS "assignee_name",
    TRY_TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD') AS "filing_date",
    YEAR(TRY_TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD')) AS "filing_year"
  FROM "PATENTS"."PATENTS"."PUBLICATIONS" t,
       LATERAL FLATTEN(input => t."assignee") assignee,
       LATERAL FLATTEN(input => t."ipc") ipc
  WHERE PARSE_JSON(ipc.value::STRING):"code"::STRING LIKE 'A61%'
    AND TRY_TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD') IS NOT NULL
    AND assignee.value::STRING IS NOT NULL
),

top_assignee AS (
  SELECT
    "assignee_name",
    COUNT(*) AS "total_applications"
  FROM a61_patents
  GROUP BY "assignee_name"
  ORDER BY "total_applications" DESC NULLS LAST
  LIMIT 1
),

assignee_years AS (
  SELECT
    "filing_year",
    COUNT(*) AS "applications_in_year"
  FROM a61_patents
  WHERE "assignee_name" = (SELECT "assignee_name" FROM top_assignee)
  GROUP BY "filing_year"
  ORDER BY "applications_in_year" DESC NULLS LAST
  LIMIT 1
)

SELECT
  "filing_year" AS "Year"
FROM assignee_years;