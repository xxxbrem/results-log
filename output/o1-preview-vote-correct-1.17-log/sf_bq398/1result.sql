SELECT "indicator_name", "indicator_code", "value", "year"
FROM WORLD_BANK.WORLD_BANK_WDI.INDICATORS_DATA
WHERE "country_name" = 'Russian Federation' AND "indicator_name" ILIKE '%debt%' AND "value" IS NOT NULL AND "year" IS NOT NULL
ORDER BY "value" DESC NULLS LAST
LIMIT 3;