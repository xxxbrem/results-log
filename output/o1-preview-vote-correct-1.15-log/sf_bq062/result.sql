SELECT
    "System",
    "LicenseType" AS "MostFrequentLicense"
FROM (
    SELECT
        t."System",
        l.value::STRING AS "LicenseType",
        COUNT(*) AS "LicenseCount",
        ROW_NUMBER() OVER (
            PARTITION BY t."System"
            ORDER BY COUNT(*) DESC NULLS LAST
        ) AS rn
    FROM
        DEPS_DEV_V1.DEPS_DEV_V1."PACKAGEVERSIONS" t,
        LATERAL FLATTEN(input => t."Licenses") l
    WHERE
        l.value::STRING IS NOT NULL AND TRIM(l.value::STRING) != ''
    GROUP BY
        t."System",
        "LicenseType"
)
WHERE rn = 1
ORDER BY "System";