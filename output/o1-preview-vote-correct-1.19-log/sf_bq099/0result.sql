WITH cpc_patents AS (
    SELECT t."publication_number",
           t."country_code",
           TRY_TO_DATE(TO_VARCHAR(t."filing_date"), 'YYYYMMDD') AS "filing_date",
           f_cpc.value::VARIANT:"code"::STRING AS "cpc_code",
           f_assignee.value::VARIANT:"name"::STRING AS "assignee_name",
           EXTRACT(YEAR FROM TRY_TO_DATE(TO_VARCHAR(t."filing_date"), 'YYYYMMDD')) AS "filing_year"
    FROM PATENTS.PATENTS.PUBLICATIONS t
    CROSS JOIN LATERAL FLATTEN(input => t."cpc") f_cpc
    CROSS JOIN LATERAL FLATTEN(input => t."assignee_harmonized") f_assignee
    WHERE f_cpc.value::VARIANT:"code"::STRING LIKE 'A01B3%'
      AND f_assignee.value::VARIANT:"name" IS NOT NULL
),
assignee_totals AS (
    SELECT "assignee_name",
           COUNT(DISTINCT "publication_number") AS "total_applications"
    FROM cpc_patents
    GROUP BY "assignee_name"
),
assignee_yearly_counts AS (
    SELECT "assignee_name", "filing_year", COUNT(DISTINCT "publication_number") AS "yearly_count"
    FROM cpc_patents
    GROUP BY "assignee_name", "filing_year"
),
assignee_max_year AS (
    SELECT ayc."assignee_name", ayc."filing_year", ayc."yearly_count"
    FROM (
        SELECT ayc.*, ROW_NUMBER() OVER (PARTITION BY "assignee_name" ORDER BY "yearly_count" DESC, "filing_year" ASC) AS rn
        FROM assignee_yearly_counts ayc
    ) ayc
    WHERE ayc.rn = 1
),
assignee_country_counts AS (
    SELECT "assignee_name", "filing_year", "country_code", COUNT(DISTINCT "publication_number") AS "country_count"
    FROM cpc_patents
    GROUP BY "assignee_name", "filing_year", "country_code"
),
assignee_max_country AS (
    SELECT acc."assignee_name", acc."filing_year", acc."country_code", acc."country_count"
    FROM (
        SELECT acc.*, ROW_NUMBER() OVER (PARTITION BY "assignee_name", "filing_year" ORDER BY "country_count" DESC) AS rn
        FROM assignee_country_counts acc
    ) acc
    WHERE acc.rn = 1
)
SELECT a."assignee_name",
       a."total_applications",
       am."filing_year" AS "year_with_most_applications",
       am."yearly_count" AS "applications_in_that_year",
       amc."country_code" AS "country_with_most_applications_in_that_year"
FROM assignee_totals a
JOIN assignee_max_year am ON a."assignee_name" = am."assignee_name"
LEFT JOIN assignee_max_country amc ON am."assignee_name" = amc."assignee_name" AND am."filing_year" = amc."filing_year"
ORDER BY a."total_applications" DESC NULLS LAST
LIMIT 3;