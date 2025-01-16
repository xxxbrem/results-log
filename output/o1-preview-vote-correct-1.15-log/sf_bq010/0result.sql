WITH cte AS (
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170701"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170702"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170703"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170704"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170705"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170706"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170707"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170708"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170709"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170710"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170711"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170712"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170713"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170714"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170715"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170716"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170717"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170718"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170719"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170720"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170721"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170722"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170723"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170724"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170725"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170726"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170727"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170728"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170729"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170730"
    UNION ALL
    SELECT "date", "fullVisitorId", "hits" FROM GA360.GOOGLE_ANALYTICS_SAMPLE."GA_SESSIONS_20170731"
),
customers_who_bought_henley AS (
    SELECT DISTINCT t."fullVisitorId"
    FROM cte t,
         LATERAL FLATTEN(input => t."hits") AS h,
         LATERAL FLATTEN(input => h.value:"product") AS p
    WHERE p.value:"v2ProductName"::STRING = 'YouTube Men''s Vintage Henley'
      AND h.value:"eCommerceAction":"action_type"::INTEGER = 6
),
purchases AS (
    SELECT p.value:"v2ProductName"::STRING AS "product_name",
           COUNT(*) AS "total_sales"
    FROM cte t,
         LATERAL FLATTEN(input => t."hits") AS h,
         LATERAL FLATTEN(input => h.value:"product") AS p
    WHERE t."fullVisitorId" IN (SELECT "fullVisitorId" FROM customers_who_bought_henley)
      AND p.value:"v2ProductName"::STRING <> 'YouTube Men''s Vintage Henley'
      AND h.value:"eCommerceAction":"action_type"::INTEGER = 6
    GROUP BY "product_name"
)
SELECT "product_name", "total_sales"
FROM purchases
ORDER BY "total_sales" DESC NULLS LAST
LIMIT 1;