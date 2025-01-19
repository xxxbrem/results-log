SELECT 
    COUNT(*) AS "Count"
FROM 
    WORLD_BANK.WORLD_BANK_INTL_DEBT.INTERNATIONAL_DEBT
WHERE 
    "country_name" ILIKE '%Russia%'
    AND "value" = 0
    AND "value" IS NOT NULL;