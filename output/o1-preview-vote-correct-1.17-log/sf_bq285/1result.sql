SELECT "zip_code", COUNT(DISTINCT "fdic_certificate_number") AS institution_count
FROM FDA.FDIC_BANKS.LOCATIONS
WHERE "state" = 'FL'
GROUP BY "zip_code"
ORDER BY institution_count DESC NULLS LAST
LIMIT 1;