SELECT
  "System",
  "License" AS "Most_Frequently_Used_License"
FROM
(
  SELECT
    t."System",
    f.value::STRING AS "License",
    COUNT(*) AS "LicenseCount",
    ROW_NUMBER() OVER (
      PARTITION BY t."System"
      ORDER BY COUNT(*) DESC NULLS LAST
    ) AS rn
  FROM
    DEPS_DEV_V1.DEPS_DEV_V1.PACKAGEVERSIONS t,
    LATERAL FLATTEN(input => t."Licenses") f
  GROUP BY
    t."System",
    f.value::STRING
)
WHERE rn = 1;