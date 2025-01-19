SELECT COUNT(*) AS "Number_of_Debt_Indicators_with_0_Value"
FROM "WORLD_BANK"."WORLD_BANK_INTL_DEBT"."INTERNATIONAL_DEBT"
WHERE "country_code" = 'RUS' AND "value" = 0;