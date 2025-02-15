WITH events_union AS (
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
purchasers AS (
   SELECT DISTINCT "USER_PSEUDO_ID"
   FROM events_union
   WHERE "EVENT_NAME" = 'purchase'
),
per_user_views AS (
   SELECT "EVENT_DATE", "USER_PSEUDO_ID", COUNT(*) AS "page_views_per_user"
   FROM events_union
   WHERE "EVENT_NAME" = 'page_view' AND "USER_PSEUDO_ID" IN (SELECT "USER_PSEUDO_ID" FROM purchasers)
   GROUP BY "EVENT_DATE", "USER_PSEUDO_ID"
)
SELECT "EVENT_DATE" AS "Date",
       SUM("page_views_per_user") AS "Total_Page_Views",
       ROUND(AVG("page_views_per_user"), 4) AS "Average_Page_Views_per_User"
FROM per_user_views
GROUP BY "EVENT_DATE"
ORDER BY "EVENT_DATE";