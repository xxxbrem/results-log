WITH youtube_transactions AS (
    SELECT DISTINCT
        h.value:"transaction":"transactionId"::STRING AS "transactionId"
    FROM
        (
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170701"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170702"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170703"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170704"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170705"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170706"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170707"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170708"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170709"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170710"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170711"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170712"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170713"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170714"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170715"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170716"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170717"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170718"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170719"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170720"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170721"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170722"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170723"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170724"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170725"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170726"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170727"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170728"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170729"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170730"
            UNION ALL
            SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170731"
        ) t,
        LATERAL FLATTEN(input => t."hits") h,
        LATERAL FLATTEN(input => h.value:"product") hp
    WHERE
        h.value:"transaction":"transactionId" IS NOT NULL
        AND hp.value:"v2ProductName"::STRING ILIKE '%YouTube%'
)
SELECT
    hp_other.value:"v2ProductName"::STRING AS "Product_Name",
    SUM(hp_other.value:"productQuantity"::NUMBER) AS "Purchase_Count"
FROM
    (
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170701"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170702"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170703"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170704"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170705"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170706"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170707"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170708"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170709"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170710"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170711"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170712"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170713"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170714"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170715"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170716"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170717"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170718"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170719"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170720"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170721"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170722"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170723"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170724"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170725"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170726"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170727"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170728"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170729"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170730"
        UNION ALL
        SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170731"
    ) t,
    LATERAL FLATTEN(input => t."hits") h,
    LATERAL FLATTEN(input => h.value:"product") hp_other
WHERE
    h.value:"transaction":"transactionId" IS NOT NULL
    AND h.value:"transaction":"transactionId"::STRING IN (SELECT "transactionId" FROM youtube_transactions)
    AND hp_other.value:"v2ProductName"::STRING IS NOT NULL
    AND hp_other.value:"v2ProductName"::STRING NOT ILIKE '%YouTube%'
GROUP BY
    "Product_Name"
ORDER BY
    "Purchase_Count" DESC NULLS LAST
LIMIT 1;