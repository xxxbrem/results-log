SELECT COUNT(DISTINCT "indicator_code") AS "number_of_debt_indicators_with_zero_value"
FROM WORLD_BANK.WORLD_BANK_INTL_DEBT.INTERNATIONAL_DEBT
WHERE "country_name" = 'Russian Federation' AND "value" = 0;