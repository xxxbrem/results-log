SELECT COUNT(*) AS "number_of_patents"
FROM PATENTS.PATENTS.PUBLICATIONS
WHERE "country_code" = 'US'
  AND "kind_code" = 'B2'
  AND "grant_date" BETWEEN 20080101 AND 20181231
  AND "claims_localized" IS NOT NULL
  AND "claims_localized" != ''
  AND "claims_localized"::STRING NOT ILIKE '%claim%';