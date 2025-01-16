WITH cpc_codes AS (
  SELECT
    t."application_number",
    cpc_f.value:"code"::STRING AS "code"
  FROM
    PATENTS.PATENTS.PUBLICATIONS t,
    LATERAL FLATTEN(input => t."cpc") cpc_f
),
ipc_codes AS (
  SELECT
    t."application_number",
    ipc_f.value:"code"::STRING AS "code"
  FROM
    PATENTS.PATENTS.PUBLICATIONS t,
    LATERAL FLATTEN(input => t."ipc") ipc_f
),
codes AS (
  SELECT "application_number", "code" FROM cpc_codes
  UNION ALL
  SELECT "application_number", "code" FROM ipc_codes
),
matched_applications AS (
  SELECT DISTINCT "application_number"
  FROM codes
  WHERE "code" LIKE 'A01B3%'
),
per_assignee_year_country AS (
  SELECT
    assignee_f.value:"name"::STRING AS "assignee_name",
    EXTRACT(year FROM TRY_TO_DATE(t."publication_date"::VARCHAR, 'YYYYMMDD')) AS "publication_year",
    t."country_code",
    COUNT(DISTINCT t."application_number") AS "applications"
  FROM
    PATENTS.PATENTS.PUBLICATIONS t,
    LATERAL FLATTEN(input => t."assignee_harmonized") assignee_f
  WHERE
    t."application_number" IN (SELECT "application_number" FROM matched_applications)
    AND assignee_f.value:"name"::STRING IS NOT NULL
    AND t."publication_date" IS NOT NULL
    AND t."country_code" IS NOT NULL
  GROUP BY
    "assignee_name",
    "publication_year",
    t."country_code"
),
total_apps_per_assignee AS (
  SELECT
    "assignee_name",
    SUM("applications") AS "total_applications"
  FROM
    per_assignee_year_country
  GROUP BY
    "assignee_name"
),
apps_per_assignee_year AS (
  SELECT
    "assignee_name",
    "publication_year",
    SUM("applications") AS "applications_in_year"
  FROM
    per_assignee_year_country
  GROUP BY
    "assignee_name",
    "publication_year"
),
max_year_per_assignee AS (
  SELECT
    "assignee_name",
    "publication_year" AS "year_with_most_applications",
    "applications_in_year",
    ROW_NUMBER() OVER (
      PARTITION BY "assignee_name"
      ORDER BY "applications_in_year" DESC NULLS LAST
    ) AS "year_rank"
  FROM
    apps_per_assignee_year
  WHERE
    "applications_in_year" IS NOT NULL
),
apps_in_peak_year_country AS (
  SELECT
    p."assignee_name",
    p."publication_year",
    p."country_code",
    p."applications"
  FROM
    per_assignee_year_country p
    INNER JOIN max_year_per_assignee m ON
      p."assignee_name" = m."assignee_name" AND
      p."publication_year" = m."year_with_most_applications"
  WHERE
    m."year_rank" = 1
),
apps_per_assignee_peak_year_country AS (
  SELECT
    "assignee_name",
    "country_code",
    SUM("applications") AS "applications_in_country"
  FROM
    apps_in_peak_year_country
  GROUP BY
    "assignee_name",
    "country_code"
),
max_country_per_assignee AS (
  SELECT
    "assignee_name",
    "country_code" AS "country_code_with_most_applications_in_that_year",
    ROW_NUMBER() OVER (
      PARTITION BY "assignee_name"
      ORDER BY "applications_in_country" DESC NULLS LAST
    ) AS "country_rank"
  FROM
    apps_per_assignee_peak_year_country
)
SELECT
  t."assignee_name",
  t."total_applications",
  y."year_with_most_applications",
  y."applications_in_year" AS "applications_in_that_year",
  c."country_code_with_most_applications_in_that_year"
FROM
  total_apps_per_assignee t
  INNER JOIN max_year_per_assignee y ON
    t."assignee_name" = y."assignee_name"
  INNER JOIN max_country_per_assignee c ON
    t."assignee_name" = c."assignee_name"
WHERE
  y."year_rank" = 1 AND
  c."country_rank" = 1
ORDER BY
  t."total_applications" DESC NULLS LAST
LIMIT 3;