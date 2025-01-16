SELECT "zip_code", COUNT(DISTINCT "fdic_certificate_number") AS bank_institutions_count
FROM FDA.FDIC_BANKS.LOCATIONS
WHERE "state_name" = 'Florida'
GROUP BY "zip_code"
ORDER BY bank_institutions_count DESC NULLS LAST
LIMIT 1;