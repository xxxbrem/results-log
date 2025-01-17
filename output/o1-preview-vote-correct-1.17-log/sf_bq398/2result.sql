SELECT "indicator_name", "indicator_code", MAX("value") AS "Value"
FROM WORLD_BANK.WORLD_BANK_INTL_DEBT.INTERNATIONAL_DEBT
WHERE "country_name" = 'Russian Federation' AND "value" IS NOT NULL
GROUP BY "indicator_name", "indicator_code"
ORDER BY "Value" DESC NULLS LAST
LIMIT 3;