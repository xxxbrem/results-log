WITH all_data AS (
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201101"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201102"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201103"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201104"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201105"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201106"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201107"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201108"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201109"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201110"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201111"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201112"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201113"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201114"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201115"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201116"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201117"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201118"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201119"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201120"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201121"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201122"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201123"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201124"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201125"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201126"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201127"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201128"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201129"
    UNION ALL
    SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201130"
),
buyers AS (
    SELECT DISTINCT "USER_PSEUDO_ID"
    FROM all_data
    WHERE "EVENT_NAME" = 'purchase' AND "USER_PSEUDO_ID" IS NOT NULL AND "USER_PSEUDO_ID" <> ''
),
page_views AS (
    SELECT "EVENT_DATE", "USER_PSEUDO_ID"
    FROM all_data
    WHERE "EVENT_NAME" = 'page_view' AND "USER_PSEUDO_ID" IN (SELECT "USER_PSEUDO_ID" FROM buyers)
),
page_views_per_user_per_day AS (
    SELECT "EVENT_DATE", "USER_PSEUDO_ID", COUNT(*) AS page_views
    FROM page_views
    GROUP BY "EVENT_DATE", "USER_PSEUDO_ID"
),
result AS (
    SELECT "EVENT_DATE",
           ROUND(AVG(page_views), 4) AS "Average_Page_Views_per_Buyer",
           SUM(page_views) AS "Total_Page_Views"
    FROM page_views_per_user_per_day
    GROUP BY "EVENT_DATE"
)
SELECT TO_DATE("EVENT_DATE", 'YYYYMMDD') AS "Date", "Average_Page_Views_per_Buyer", "Total_Page_Views"
FROM result
ORDER BY "Date";