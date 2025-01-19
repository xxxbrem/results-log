SELECT
    "indicator_name",
    SUM("value") AS "Debt_Value"
FROM
    WORLD_BANK.WORLD_BANK_INTL_DEBT.INTERNATIONAL_DEBT
WHERE
    "country_code" = 'RUS' AND "value" IS NOT NULL
GROUP BY
    "indicator_name"
ORDER BY
    "Debt_Value" DESC NULLS LAST
LIMIT 3;