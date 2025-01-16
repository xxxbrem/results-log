SELECT
  sub."System",
  sub."LicenseName" AS "Most_Frequent_License"
FROM
(
  SELECT
    t."System",
    f.value::STRING AS "LicenseName",
    COUNT(*) AS "LicenseCount",
    ROW_NUMBER() OVER (
      PARTITION BY t."System"
      ORDER BY COUNT(*) DESC NULLS LAST
    ) AS rn
  FROM
    DEPS_DEV_V1.DEPS_DEV_V1.PACKAGEVERSIONS t,
    LATERAL FLATTEN(input => t."Licenses") f
  WHERE
    f.value IS NOT NULL
  GROUP BY
    t."System",
    f.value::STRING
) sub
WHERE
  sub.rn = 1;