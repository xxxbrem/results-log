SELECT q."System", q."LicenseName" AS "MostFrequentLicense"
FROM (
    SELECT 
        t."System",
        REGEXP_REPLACE(f.value::STRING, '[\\"\\\']', '') AS "LicenseName",
        COUNT(*) AS "LicenseCount",
        ROW_NUMBER() OVER (
            PARTITION BY t."System" 
            ORDER BY COUNT(*) DESC NULLS LAST
        ) AS rn
    FROM DEPS_DEV_V1.DEPS_DEV_V1.PACKAGEVERSIONS t,
    LATERAL FLATTEN(input => t."Licenses") f
    WHERE f.value IS NOT NULL
    GROUP BY 
        t."System", 
        REGEXP_REPLACE(f.value::STRING, '[\\"\\\']', '')
) q
WHERE q.rn = 1;