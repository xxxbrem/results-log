SELECT lc."System", lc."License" AS "MostFrequentLicense"
FROM (
    SELECT t."System", f.value::STRING AS "License", COUNT(*) AS "LicenseCount",
           ROW_NUMBER() OVER (PARTITION BY t."System" ORDER BY COUNT(*) DESC NULLS LAST) AS rn
    FROM DEPS_DEV_V1.DEPS_DEV_V1.PACKAGEVERSIONS t,
         LATERAL FLATTEN(INPUT => t."Licenses") f
    WHERE f.value IS NOT NULL
    GROUP BY t."System", f.value::STRING
) lc
WHERE rn = 1
ORDER BY lc."System";