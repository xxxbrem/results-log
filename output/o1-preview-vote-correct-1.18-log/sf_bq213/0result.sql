SELECT
    SUBSTR(f.value:"code"::STRING, 1, 4) AS "Most_common_IPC4_Code",
    COUNT(*) AS "Count"
FROM
    PATENTS.PATENTS.PUBLICATIONS t,
    LATERAL FLATTEN(input => t."ipc") f
WHERE
    t."country_code" = 'US'
    AND t."kind_code" = 'B2'
    AND t."grant_date" BETWEEN '20220601' AND '20220831'
GROUP BY
    "Most_common_IPC4_Code"
ORDER BY
    "Count" DESC NULLS LAST
LIMIT 1;