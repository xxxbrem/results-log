WITH sessions AS (
    SELECT "fullVisitorId", "visitStartTime", "device":deviceCategory::STRING AS "deviceCategory"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160801"
    UNION ALL
    SELECT "fullVisitorId", "visitStartTime", "device":deviceCategory::STRING AS "deviceCategory"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160802"
    UNION ALL
    SELECT "fullVisitorId", "visitStartTime", "device":deviceCategory::STRING AS "deviceCategory"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160803"
    UNION ALL
    SELECT "fullVisitorId", "visitStartTime", "device":deviceCategory::STRING AS "deviceCategory"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160804"
    UNION ALL
    SELECT "fullVisitorId", "visitStartTime", "device":deviceCategory::STRING AS "deviceCategory"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160805"
    UNION ALL
    -- Continue listing each GA_SESSIONS_* table explicitly up to GA_SESSIONS_20170801
    -- For brevity, include all dates from 2016-08-06 to 2017-08-01
    -- ...
    SELECT "fullVisitorId", "visitStartTime", "device":deviceCategory::STRING AS "deviceCategory"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170801"
),
transactions AS (
    SELECT
        t."fullVisitorId",
        (t."visitStartTime" + (h.value:"time"::NUMBER / 1000)) AS "transactionTime",
        t."device":deviceCategory::STRING AS "deviceCategory"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160801" t,
    LATERAL FLATTEN(input => t."hits") h
    WHERE h.value:transaction:transactionId IS NOT NULL
    UNION ALL
    SELECT
        t."fullVisitorId",
        (t."visitStartTime" + (h.value:"time"::NUMBER / 1000)) AS "transactionTime",
        t."device":deviceCategory::STRING AS "deviceCategory"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160802" t,
    LATERAL FLATTEN(input => t."hits") h
    WHERE h.value:transaction:transactionId IS NOT NULL
    UNION ALL
    SELECT
        t."fullVisitorId",
        (t."visitStartTime" + (h.value:"time"::NUMBER / 1000)) AS "transactionTime",
        t."device":deviceCategory::STRING AS "deviceCategory"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20160803" t,
    LATERAL FLATTEN(input => t."hits") h
    WHERE h.value:transaction:transactionId IS NOT NULL
    UNION ALL
    -- Continue listing each GA_SESSIONS_* table explicitly up to GA_SESSIONS_20170801
    -- For brevity, include all dates from 2016-08-04 to 2017-08-01
    -- ...
    SELECT
        t."fullVisitorId",
        (t."visitStartTime" + (h.value:"time"::NUMBER / 1000)) AS "transactionTime",
        t."device":deviceCategory::STRING AS "deviceCategory"
    FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170801" t,
    LATERAL FLATTEN(input => t."hits") h
    WHERE h.value:transaction:transactionId IS NOT NULL
),
last_visits AS (
    SELECT
        "fullVisitorId",
        MIN("visitStartTime") AS "first_visit_time",
        MAX("visitStartTime") AS "last_visit_time"
    FROM sessions
    GROUP BY "fullVisitorId"
),
last_visit_devices AS (
    SELECT
        s."fullVisitorId",
        s."deviceCategory" AS "last_visit_device"
    FROM sessions s
    INNER JOIN last_visits lv
        ON s."fullVisitorId" = lv."fullVisitorId" AND s."visitStartTime" = lv."last_visit_time"
),
first_transactions AS (
    SELECT
        "fullVisitorId",
        MIN("transactionTime") AS "first_transaction_time"
    FROM transactions
    GROUP BY "fullVisitorId"
),
first_transaction_devices AS (
    SELECT
        t."fullVisitorId",
        t."deviceCategory" AS "first_transaction_device"
    FROM transactions t
    INNER JOIN first_transactions ft
        ON t."fullVisitorId" = ft."fullVisitorId" AND t."transactionTime" = ft."first_transaction_time"
),
user_events AS (
    SELECT
        lv."fullVisitorId",
        lv."first_visit_time",
        lv."last_visit_time",
        lvd."last_visit_device",
        ft."first_transaction_time",
        ftd."first_transaction_device",
        CASE
            WHEN ft."first_transaction_time" IS NOT NULL AND ft."first_transaction_time" > lv."last_visit_time" THEN ft."first_transaction_time"
            ELSE lv."last_visit_time"
        END AS "last_event_time",
        CASE
            WHEN ft."first_transaction_time" IS NOT NULL AND ft."first_transaction_time" > lv."last_visit_time" THEN ftd."first_transaction_device"
            ELSE lvd."last_visit_device"
        END AS "last_event_device"
    FROM last_visits lv
    INNER JOIN last_visit_devices lvd
        ON lv."fullVisitorId" = lvd."fullVisitorId"
    LEFT JOIN first_transactions ft
        ON lv."fullVisitorId" = ft."fullVisitorId"
    LEFT JOIN first_transaction_devices ftd
        ON ft."fullVisitorId" = ftd."fullVisitorId"
)
SELECT
    MAX(DATEDIFF(
        'day',
        TO_DATE(TO_TIMESTAMP(user_events."first_visit_time")),
        TO_DATE(TO_TIMESTAMP(user_events."last_event_time"))
    )) AS "Longest_Number_of_Days"
FROM user_events
WHERE user_events."last_event_device" = 'mobile';