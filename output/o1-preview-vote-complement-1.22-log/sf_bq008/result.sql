WITH all_sessions AS (
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170101"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170102"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170103"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170104"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170105"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170106"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170107"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170108"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170109"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170110"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170111"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170112"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170113"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170114"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170115"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170116"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170117"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170118"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170119"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170120"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170121"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170122"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170123"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170124"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170125"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170126"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170127"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170128"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170129"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170130"
    UNION ALL
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170131"
),
home_hits AS (
    SELECT
        t."fullVisitorId",
        t."visitId",
        h.value:"hitNumber"::INTEGER AS "hitNumber",
        h.value:"page":"pagePath"::STRING AS "currentPagePath",
        h.value:"time"::INTEGER AS "currentHitTime",
        t."hits"
    FROM all_sessions t,
         LATERAL FLATTEN(input => t."hits") h
    WHERE t."trafficSource":"campaign"::STRING = 'Data Share Promo'
      AND h.value:"page":"pagePath"::STRING LIKE '/home%'
),
next_hits AS (
    SELECT
        h."fullVisitorId",
        h."visitId",
        h."hitNumber" AS "currentHitNumber",
        h."currentPagePath",
        h."currentHitTime",
        next_h.value:"hitNumber"::INTEGER AS "nextHitNumber",
        next_h.value:"page":"pagePath"::STRING AS "nextPagePath",
        next_h.value:"time"::INTEGER AS "nextHitTime",
        (next_h.value:"time"::INTEGER - h."currentHitTime") / 1000.0 AS "durationSeconds"
    FROM home_hits h,
         LATERAL FLATTEN(input => h."hits") next_h
    WHERE next_h.value:"hitNumber"::INTEGER = h."hitNumber" + 1
),
most_common_next_page AS (
    SELECT
        "nextPagePath",
        COUNT(*) AS "pageCount"
    FROM next_hits
    GROUP BY "nextPagePath"
    ORDER BY "pageCount" DESC NULLS LAST, "nextPagePath" ASC
    LIMIT 1
),
maximum_duration AS (
    SELECT
        MAX("durationSeconds") AS "Maximum_Duration_Seconds"
    FROM next_hits
)
SELECT
    mcnp."nextPagePath" AS "Most_Common_Next_Page",
    ROUND(md."Maximum_Duration_Seconds", 4) AS "Maximum_Duration_Seconds"
FROM most_common_next_page mcnp, maximum_duration md;