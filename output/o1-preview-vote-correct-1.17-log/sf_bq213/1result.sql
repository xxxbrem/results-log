SELECT SUBSTR(ipc_data.value:"code"::STRING, 1, 4) AS "ipc4_code",
       COUNT(DISTINCT t."publication_number") AS "number_of_patents"
FROM PATENTS.PATENTS.PUBLICATIONS t,
     LATERAL FLATTEN(input => t."ipc") ipc_data
WHERE t."country_code" = 'US'
  AND t."kind_code" = 'B2'
  AND t."publication_date" BETWEEN 20220601 AND 20220831
GROUP BY "ipc4_code"
ORDER BY "number_of_patents" DESC NULLS LAST
LIMIT 1;