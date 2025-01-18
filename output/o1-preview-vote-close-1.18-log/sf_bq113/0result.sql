WITH
-- Calculate average construction employment for each county in Utah in 2000
employment_2000 AS (
    SELECT
        c."county_name",
        t."geoid",
        AVG(t."month3_emplvl_23_construction") AS avg_emplvl_2000
    FROM (
        SELECT * FROM "BLS"."BLS_QCEW"."_2000_Q1"
        UNION ALL
        SELECT * FROM "BLS"."BLS_QCEW"."_2000_Q2"
        UNION ALL
        SELECT * FROM "BLS"."BLS_QCEW"."_2000_Q3"
        UNION ALL
        SELECT * FROM "BLS"."BLS_QCEW"."_2000_Q4"
    ) t
    JOIN "BLS"."GEO_US_BOUNDARIES"."COUNTIES" c ON t."geoid" = c."geo_id"
    WHERE
        c."state_fips_code" = '49'
        AND t."month3_emplvl_23_construction" IS NOT NULL
    GROUP BY
        c."county_name",
        t."geoid"
),
-- Calculate average construction employment for each county in Utah in 2018
employment_2018 AS (
    SELECT
        c."county_name",
        t."geoid",
        AVG(t."month3_emplvl_23_construction") AS avg_emplvl_2018
    FROM (
        SELECT * FROM "BLS"."BLS_QCEW"."_2018_Q1"
        UNION ALL
        SELECT * FROM "BLS"."BLS_QCEW"."_2018_Q2"
        UNION ALL
        SELECT * FROM "BLS"."BLS_QCEW"."_2018_Q3"
        UNION ALL
        SELECT * FROM "BLS"."BLS_QCEW"."_2018_Q4"
    ) t
    JOIN "BLS"."GEO_US_BOUNDARIES"."COUNTIES" c ON t."geoid" = c."geo_id"
    WHERE
        c."state_fips_code" = '49'
        AND t."month3_emplvl_23_construction" IS NOT NULL
    GROUP BY
        c."county_name",
        t."geoid"
)
SELECT
    e2018."county_name",
    ROUND(
        ((e2018.avg_emplvl_2018 - e2000.avg_emplvl_2000) / NULLIF(e2000.avg_emplvl_2000, 0)) * 100,
        4
    ) AS "percentage_increase"
FROM
    employment_2000 e2000
JOIN
    employment_2018 e2018 ON e2000."geoid" = e2018."geoid"
ORDER BY
    "percentage_increase" DESC NULLS LAST
LIMIT 1;