SELECT CS."region", ROUND(MEDIAN(IND."value"), 4) AS "Median_GDP"
FROM WORLD_BANK.WORLD_BANK_WDI."INDICATORS_DATA" IND
JOIN WORLD_BANK.WORLD_BANK_WDI."COUNTRY_SUMMARY" CS
  ON IND."country_code" = CS."country_code"
WHERE IND."indicator_code" = 'NY.GDP.MKTP.KD'
  AND IND."year" = 2020
  AND CS."region" IS NOT NULL
GROUP BY CS."region"
ORDER BY "Median_GDP" DESC NULLS LAST
LIMIT 1