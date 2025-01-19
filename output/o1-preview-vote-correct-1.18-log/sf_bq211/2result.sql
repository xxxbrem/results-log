SELECT COUNT(*) AS "number_of_patents"
FROM PATENTS.PATENTS."PUBLICATIONS" p
WHERE p."grant_date" >= 20100101
  AND p."grant_date" <= 20231231
  AND p."grant_date" IS NOT NULL
  AND p."grant_date" != 0
  AND p."country_code" = 'CN'
  AND p."family_id" IN (
    SELECT "family_id"
    FROM PATENTS.PATENTS."PUBLICATIONS"
    WHERE "application_number" IS NOT NULL
    GROUP BY "family_id"
    HAVING COUNT(DISTINCT "application_number") > 1
  );