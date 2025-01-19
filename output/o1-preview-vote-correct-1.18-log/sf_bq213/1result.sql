WITH MostCommonIPC AS (
    SELECT
        SUBSTR(f.value:"code"::STRING, 1, 4) AS "most_common_ipc4_code",
        COUNT(*) AS "code_count"
    FROM
        PATENTS.PATENTS.PUBLICATIONS t,
        LATERAL FLATTEN(input => t."ipc") f
    WHERE
        t."country_code" = 'US'
        AND t."kind_code" = 'B2'
        AND t."publication_date" BETWEEN 20220601 AND 20220831
    GROUP BY
        "most_common_ipc4_code"
    ORDER BY
        "code_count" DESC NULLS LAST
    LIMIT 1
), IPC_Description AS (
    SELECT
        "symbol",
        "titleFull" AS "code_description"
    FROM
        PATENTS.PATENTS.CPC_DEFINITION
    WHERE
        LEFT("symbol", 4) = (SELECT "most_common_ipc4_code" FROM MostCommonIPC)
    ORDER BY
        LENGTH("symbol") ASC
    LIMIT 1
)
SELECT
    MostCommonIPC."most_common_ipc4_code",
    IPC_Description."code_description"
FROM
    MostCommonIPC
    LEFT JOIN
    IPC_Description ON 1=1;