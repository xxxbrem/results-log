SELECT cs."region", MEDIAN(id."value") AS "median_gdp"
FROM "WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA" id
JOIN "WORLD_BANK"."WORLD_BANK_WDI"."COUNTRY_SUMMARY" cs
  ON id."country_code" = cs."country_code"
WHERE id."indicator_code" = 'NY.GDP.MKTP.KD'
  AND id."year" = (
    SELECT MAX("year")
    FROM "WORLD_BANK"."WORLD_BANK_WDI"."INDICATORS_DATA"
    WHERE "indicator_code" = 'NY.GDP.MKTP.KD'
  )
  AND cs."region" IS NOT NULL AND cs."region" != ''
  AND id."value" IS NOT NULL
GROUP BY cs."region"
ORDER BY "median_gdp" DESC NULLS LAST
LIMIT 1;