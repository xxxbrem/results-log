WITH patents_with_claim AS (
  SELECT DISTINCT t."publication_number"
  FROM PATENTS.PATENTS.PUBLICATIONS t,
       LATERAL FLATTEN(input => t."claims_localized") f
  WHERE t."country_code" = 'US'
    AND t."kind_code" = 'B2'
    AND t."grant_date" BETWEEN 20080101 AND 20181231
    AND t."claims_localized" IS NOT NULL
    AND f.value:"language" = 'en'
    AND LOWER(f.value:"text"::STRING) LIKE '%claim%'
)
SELECT COUNT(DISTINCT t."publication_number") AS "Number_of_Patents"
FROM PATENTS.PATENTS.PUBLICATIONS t
WHERE t."country_code" = 'US'
  AND t."kind_code" = 'B2'
  AND t."grant_date" BETWEEN 20080101 AND 20181231
  AND t."claims_localized" IS NOT NULL
  AND t."publication_number" NOT IN (SELECT "publication_number" FROM patents_with_claim);