SELECT cs."region" AS "Region", MEDIAN(id."value") AS "Median_GDP"
FROM WORLD_BANK.WORLD_BANK_WDI."INDICATORS_DATA" AS id
JOIN WORLD_BANK.WORLD_BANK_WDI."COUNTRY_SUMMARY" AS cs
  ON id."country_code" = cs."country_code"
WHERE id."indicator_code" = 'NY.GDP.MKTP.KD'
  AND id."year" = 2019
  AND cs."region" IS NOT NULL
GROUP BY cs."region"
ORDER BY "Median_GDP" DESC NULLS LAST
LIMIT 1;