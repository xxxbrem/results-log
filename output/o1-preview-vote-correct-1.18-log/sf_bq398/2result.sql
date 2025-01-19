SELECT "indicator_name", "indicator_code", MAX("value") AS "Maximum_Debt_Value"
FROM "WORLD_BANK"."WORLD_BANK_INTL_DEBT"."INTERNATIONAL_DEBT"
WHERE "country_name" = 'Russian Federation' AND "indicator_name" ILIKE '%Debt%'
GROUP BY "indicator_name", "indicator_code"
ORDER BY "Maximum_Debt_Value" DESC NULLS LAST
LIMIT 3;