SELECT COUNT(*) AS "Total_Patents"
FROM (
  SELECT cp."publication_number"
  FROM PATENTS.PATENTS.PUBLICATIONS cp
  WHERE cp."country_code" = 'US'
    AND cp."kind_code" = 'B2'
    AND cp."grant_date" BETWEEN 20080101 AND 20181231
  EXCEPT
  SELECT DISTINCT cp2."publication_number"
  FROM PATENTS.PATENTS.PUBLICATIONS cp2,
       TABLE(FLATTEN(input => cp2."claims_localized")) cl
  WHERE cp2."country_code" = 'US'
    AND cp2."kind_code" = 'B2'
    AND cp2."grant_date" BETWEEN 20080101 AND 20181231
    AND LOWER(cl.value:"text"::STRING) LIKE '%claim%'
);