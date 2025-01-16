WITH license_counts AS (
    SELECT
        t."System",
        l.value::STRING AS "License",
        COUNT(*) AS "License_Count"
    FROM
        "DEPS_DEV_V1"."DEPS_DEV_V1"."PACKAGEVERSIONS" t,
        LATERAL FLATTEN(INPUT => PARSE_JSON(t."Licenses")) l
    WHERE
        t."Licenses" IS NOT NULL
        AND l.value::STRING IS NOT NULL
        AND l.value::STRING != ''
    GROUP BY
        t."System",
        l.value::STRING
),
max_license_counts AS (
    SELECT
        "System",
        MAX("License_Count") AS "Max_License_Count"
    FROM
        license_counts
    GROUP BY
        "System"
)
SELECT
    lc."System",
    lc."License" AS "Most_Frequent_License"
FROM
    license_counts lc
    JOIN max_license_counts mlc
        ON lc."System" = mlc."System" AND lc."License_Count" = mlc."Max_License_Count";