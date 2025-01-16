SELECT "System", "License" AS "MostFrequentlyUsedLicense"
FROM (
  SELECT t."System", l.value::VARIANT::STRING AS "License", COUNT(*) AS "LicenseCount",
         ROW_NUMBER() OVER (PARTITION BY t."System" ORDER BY COUNT(*) DESC NULLS LAST) AS rn
  FROM DEPS_DEV_V1.DEPS_DEV_V1.PACKAGEVERSIONS t,
       LATERAL FLATTEN(input => t."Licenses") l
  GROUP BY t."System", l.value::VARIANT::STRING
) sub
WHERE rn = 1;