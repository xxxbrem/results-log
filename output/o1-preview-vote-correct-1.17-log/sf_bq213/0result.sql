SELECT SUBSTR(f.value:"code"::STRING, 1, 4) AS ipc4, COUNT(*) AS count
FROM PATENTS.PATENTS.PUBLICATIONS t,
LATERAL FLATTEN(input => t."ipc") f
WHERE t."country_code" = 'US'
  AND t."kind_code" = 'B2'
  AND t."publication_date" >= 20220601 AND t."publication_date" <= 20220831
GROUP BY ipc4
ORDER BY count DESC NULLS LAST
LIMIT 1;