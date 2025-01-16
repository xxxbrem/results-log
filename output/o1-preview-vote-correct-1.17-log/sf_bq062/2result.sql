SELECT main."System", main."License", main."PackageCount"
FROM (
  SELECT t."System",
         REGEXP_REPLACE(l.value::STRING, '["]+', '') AS "License",
         COUNT(*) AS "PackageCount",
         ROW_NUMBER() OVER (
           PARTITION BY t."System"
           ORDER BY COUNT(*) DESC NULLS LAST
         ) AS rn
  FROM DEPS_DEV_V1.DEPS_DEV_V1.PACKAGEVERSIONS t,
       LATERAL FLATTEN(input => t."Licenses") l
  WHERE l.value::STRING IS NOT NULL
  GROUP BY t."System", REGEXP_REPLACE(l.value::STRING, '["]+', '')
) main
WHERE main.rn = 1;