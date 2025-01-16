WITH base_data AS (
    SELECT
        t."publication_number",
        t."publication_date",
        t."country_code",
        f_assignee.value:"name"::STRING AS "assignee_name",
        f_cpc.value:"code"::STRING AS "cpc_code"
    FROM
        PATENTS.PATENTS.PUBLICATIONS t,
        LATERAL FLATTEN(input => t."assignee_harmonized") f_assignee,
        LATERAL FLATTEN(input => t."cpc") f_cpc
    WHERE
        f_cpc.value:"code"::STRING LIKE 'A01B3%'
        AND f_assignee.value:"name"::STRING IS NOT NULL
),
assignee_total AS (
    SELECT
        "assignee_name",
        COUNT(DISTINCT "publication_number") AS "total_applications"
    FROM
        base_data
    GROUP BY
        "assignee_name"
),
top_assignees AS (
    SELECT
        "assignee_name",
        "total_applications"
    FROM
        assignee_total
    ORDER BY
        "total_applications" DESC NULLS LAST
    LIMIT 3
),
assignee_yearly AS (
    SELECT
        "assignee_name",
        EXTRACT(year FROM 
            CASE 
                WHEN "publication_date" >= 1e15 THEN TO_TIMESTAMP_NTZ("publication_date"/1000000)
                WHEN "publication_date" >= 1e12 THEN TO_TIMESTAMP_NTZ("publication_date"/1000)
                ELSE TO_TIMESTAMP_NTZ("publication_date")
            END
        ) AS "year",
        COUNT(DISTINCT "publication_number") AS "applications_in_year"
    FROM
        base_data
    WHERE
        "assignee_name" IN (SELECT "assignee_name" FROM top_assignees)
    GROUP BY
        "assignee_name", "year"
),
assignee_peak_year AS (
    SELECT
        "assignee_name",
        "year" AS "year_with_most_applications",
        "applications_in_year",
        ROW_NUMBER() OVER (PARTITION BY "assignee_name" ORDER BY "applications_in_year" DESC, "year" ASC) AS rn
    FROM
        assignee_yearly
    WHERE
        "year" IS NOT NULL
),
assignee_country_in_peak_year AS (
    SELECT
        bd."assignee_name",
        bd."country_code",
        COUNT(DISTINCT bd."publication_number") AS "country_applications"
    FROM
        base_data bd
    JOIN assignee_peak_year py ON bd."assignee_name" = py."assignee_name" AND py.rn = 1
    WHERE
        EXTRACT(year FROM 
            CASE 
                WHEN bd."publication_date" >= 1e15 THEN TO_TIMESTAMP_NTZ(bd."publication_date"/1000000)
                WHEN bd."publication_date" >= 1e12 THEN TO_TIMESTAMP_NTZ(bd."publication_date"/1000)
                ELSE TO_TIMESTAMP_NTZ(bd."publication_date")
            END
        ) = py."year_with_most_applications"
    GROUP BY
        bd."assignee_name", bd."country_code"
),
assignee_peak_country AS (
    SELECT
        "assignee_name",
        "country_code",
        ROW_NUMBER() OVER (PARTITION BY "assignee_name" ORDER BY "country_applications" DESC NULLS LAST) AS rn
    FROM
        assignee_country_in_peak_year
)
SELECT
    ta."assignee_name",
    ta."total_applications",
    py."year_with_most_applications",
    py."applications_in_year",
    pc."country_code"
FROM
    top_assignees ta
JOIN
    assignee_peak_year py ON ta."assignee_name" = py."assignee_name" AND py.rn = 1
JOIN
    assignee_peak_country pc ON ta."assignee_name" = pc."assignee_name" AND pc.rn = 1
ORDER BY
    ta."total_applications" DESC NULLS LAST;