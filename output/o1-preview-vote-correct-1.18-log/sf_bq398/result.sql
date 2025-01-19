SELECT "indicator_name", MAX("value") AS "max_value"
FROM WORLD_BANK.WORLD_BANK_INTL_DEBT.INTERNATIONAL_DEBT
WHERE "country_name" = 'Russian Federation' 
  AND "indicator_name" ILIKE '%debt%'
  AND "value" IS NOT NULL
GROUP BY "indicator_name"
ORDER BY "max_value" DESC NULLS LAST
LIMIT 3;