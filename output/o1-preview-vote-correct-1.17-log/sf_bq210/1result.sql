SELECT COUNT(DISTINCT t."publication_number") AS "number_of_patents"
FROM "PATENTS"."PATENTS"."PUBLICATIONS" t
WHERE t."country_code" = 'US'
  AND t."kind_code" = 'B2'
  AND t."grant_date" BETWEEN 20080101 AND 20181231
  AND t."publication_number" NOT IN (
    SELECT t."publication_number"
    FROM "PATENTS"."PATENTS"."PUBLICATIONS" t,
         LATERAL FLATTEN(input => t."claims_localized") c
    WHERE t."country_code" = 'US'
      AND t."kind_code" = 'B2'
      AND t."grant_date" BETWEEN 20080101 AND 20181231
      AND LOWER(c.value:"text"::STRING) LIKE '%claim%'
)