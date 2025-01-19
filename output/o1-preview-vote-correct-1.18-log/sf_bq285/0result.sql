SELECT "zip_code", COUNT(DISTINCT "fdic_certificate_number") AS "num_institutions"
FROM FDA.FDIC_BANKS.LOCATIONS
WHERE "state_name" = 'Florida'
GROUP BY "zip_code"
ORDER BY "num_institutions" DESC NULLS LAST
LIMIT 1;