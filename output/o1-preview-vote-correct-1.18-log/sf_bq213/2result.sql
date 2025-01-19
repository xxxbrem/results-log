SELECT
  ipc_code_4_digit AS "IPC_code",
  COUNT(*) AS "count"
FROM (
  SELECT
    SUBSTR(f.value::VARIANT:"code"::STRING, 0, 4) AS ipc_code_4_digit
  FROM PATENTS.PATENTS.PUBLICATIONS t,
       LATERAL FLATTEN(input => t."ipc") f
  WHERE t."country_code" = 'US'
    AND t."kind_code" = 'B2'
    AND t."grant_date" BETWEEN 20220601 AND 20220831
)
GROUP BY ipc_code_4_digit
ORDER BY "count" DESC NULLS LAST
LIMIT 1;