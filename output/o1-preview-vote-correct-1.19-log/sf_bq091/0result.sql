WITH Assignee_Applications AS (
  SELECT
    f_assignee.value::STRING AS "assignee_name",
    EXTRACT(year FROM TO_DATE(t."filing_date"::VARCHAR, 'YYYYMMDD')) AS "filing_year"
  FROM PATENTS.PATENTS.PUBLICATIONS t,
       LATERAL FLATTEN(input => t."assignee") f_assignee,
       LATERAL FLATTEN(input => t."ipc") f_ipc
  WHERE f_ipc.value:"code"::STRING LIKE 'A61%'
    AND t."filing_date" IS NOT NULL
    AND t."filing_date" != 0
),

Top_Assignee AS (
  SELECT "assignee_name"
  FROM Assignee_Applications
  GROUP BY "assignee_name"
  ORDER BY COUNT(*) DESC NULLS LAST
  LIMIT 1
),

Year_Counts AS (
  SELECT "filing_year", COUNT(*) AS application_count
  FROM Assignee_Applications
  WHERE "assignee_name" = (SELECT "assignee_name" FROM Top_Assignee)
  GROUP BY "filing_year"
  ORDER BY application_count DESC NULLS LAST
  LIMIT 1
)

SELECT "filing_year" AS "Year"
FROM Year_Counts;