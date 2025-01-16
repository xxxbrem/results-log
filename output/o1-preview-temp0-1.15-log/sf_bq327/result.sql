SELECT COUNT(DISTINCT "indicator_code") AS "number_of_debt_indicators_zero"
FROM WORLD_BANK.WORLD_BANK_INTL_DEBT.INTERNATIONAL_DEBT
WHERE "country_name" = 'Russian Federation'
  AND "value" = 0
  AND "value" IS NOT NULL;