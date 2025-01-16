WITH
"assignee_total" AS (
  SELECT
    assignee_info.value:"name"::STRING AS "assignee_name",
    COUNT(DISTINCT t."publication_number") AS "total_applications"
  FROM
    "PATENTS"."PATENTS"."PUBLICATIONS" t,
    LATERAL FLATTEN(input => t."cpc") cpc_info,
    LATERAL FLATTEN(input => t."assignee_harmonized") assignee_info
  WHERE
    cpc_info.value:"code"::STRING LIKE 'A01B3%'
  GROUP BY
    "assignee_name"
),
"assignee_yearly" AS (
  SELECT
    assignee_info.value:"name"::STRING AS "assignee_name",
    CAST(SUBSTRING(t."publication_date"::VARCHAR, 1, 4) AS INT) AS "publication_year",
    COUNT(DISTINCT t."publication_number") AS "applications_in_year"
  FROM
    "PATENTS"."PATENTS"."PUBLICATIONS" t,
    LATERAL FLATTEN(input => t."cpc") cpc_info,
    LATERAL FLATTEN(input => t."assignee_harmonized") assignee_info
  WHERE
    cpc_info.value:"code"::STRING LIKE 'A01B3%'
    AND t."publication_date" IS NOT NULL
  GROUP BY
    "assignee_name",
    "publication_year"
),
"max_year_per_assignee" AS (
  SELECT
    "assignee_name",
    "publication_year" AS "year_with_most_applications",
    "applications_in_year",
    ROW_NUMBER() OVER(PARTITION BY "assignee_name" ORDER BY "applications_in_year" DESC NULLS LAST, "publication_year" DESC NULLS LAST) AS "rn"
  FROM
    "assignee_yearly"
  WHERE
    "applications_in_year" IS NOT NULL
),
"assignee_year_country" AS (
  SELECT
    assignee_info.value:"name"::STRING AS "assignee_name",
    CAST(SUBSTRING(t."publication_date"::VARCHAR, 1, 4) AS INT) AS "publication_year",
    t."country_code",
    COUNT(DISTINCT t."publication_number") AS "applications_in_country"
  FROM
    "PATENTS"."PATENTS"."PUBLICATIONS" t,
    LATERAL FLATTEN(input => t."cpc") cpc_info,
    LATERAL FLATTEN(input => t."assignee_harmonized") assignee_info
  WHERE
    cpc_info.value:"code"::STRING LIKE 'A01B3%'
    AND t."publication_date" IS NOT NULL
  GROUP BY
    "assignee_name",
    "publication_year",
    t."country_code"
),
"max_country_per_assignee" AS (
  SELECT
    ays."assignee_name",
    ays."publication_year",
    ays."country_code" AS "country_code_with_most_applications_during_that_year",
    ays."applications_in_country",
    ROW_NUMBER() OVER(
      PARTITION BY ays."assignee_name"
      ORDER BY ays."applications_in_country" DESC NULLS LAST
    ) AS "rn"
  FROM
    "assignee_year_country" ays
    JOIN (
      SELECT
        "assignee_name",
        "year_with_most_applications"
      FROM
        "max_year_per_assignee"
      WHERE
        "rn" = 1
    ) mypa
      ON ays."assignee_name" = mypa."assignee_name" AND ays."publication_year" = mypa."year_with_most_applications"
),
"top_assignees" AS (
  SELECT
    "assignee_name",
    "total_applications",
    ROW_NUMBER() OVER (ORDER BY "total_applications" DESC NULLS LAST) AS "rn"
  FROM
    "assignee_total"
  WHERE
    "total_applications" IS NOT NULL
)
SELECT
  ta."assignee_name",
  ta."total_applications",
  mypa."year_with_most_applications",
  mypa."applications_in_year" AS "applications_in_that_year",
  mca."country_code_with_most_applications_during_that_year"
FROM
  "top_assignees" ta
  JOIN "max_year_per_assignee" mypa ON ta."assignee_name" = mypa."assignee_name" AND mypa."rn" = 1
  JOIN "max_country_per_assignee" mca ON ta."assignee_name" = mca."assignee_name" AND mca."rn" = 1
WHERE
  ta."rn" <= 3
ORDER BY
  ta."total_applications" DESC NULLS LAST;