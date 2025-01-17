SELECT "indicator_name", MAX("value") AS "value"
FROM WORLD_BANK.WORLD_BANK_INTL_DEBT.INTERNATIONAL_DEBT
WHERE "country_name" = 'Russian Federation' AND "indicator_name" LIKE '%debt%'
GROUP BY "indicator_name"
ORDER BY "value" DESC NULLS LAST
LIMIT 3;