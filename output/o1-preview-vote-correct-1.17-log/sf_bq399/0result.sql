SELECT t."region", t."country_name", t."average_birth_rate"
FROM (
  SELECT c."region", c."short_name" AS "country_name", ROUND(AVG(i."value"), 4) AS "average_birth_rate",
         ROW_NUMBER() OVER (PARTITION BY c."region" ORDER BY AVG(i."value") DESC NULLS LAST) AS "rn"
  FROM "WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA" i
  JOIN "WORLD_BANK"."WORLD_BANK_WDI"."COUNTRY_SUMMARY" c
    ON i."country_code" = c."country_code"
  WHERE i."indicator_code" = 'SP.DYN.CBRT.IN'
    AND i."year" BETWEEN 1980 AND 1989
    AND c."income_group" = 'High income'
  GROUP BY c."region", c."short_name"
) t
WHERE t."rn" = 1;