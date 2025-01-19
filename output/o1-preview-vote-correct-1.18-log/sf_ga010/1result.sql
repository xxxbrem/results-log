SELECT
  s."Channel" AS "Channel with Fourth Highest Sessions",
  COUNT(DISTINCT s."ga_session_id") AS "Sessions"
FROM (
  SELECT
    CASE
      WHEN t."TRAFFIC_SOURCE":"source"::STRING = '(direct)'
           AND t."TRAFFIC_SOURCE":"medium"::STRING IN ('(not set)', '(none)') THEN 'Direct'
      WHEN t."TRAFFIC_SOURCE":"campaign"::STRING ILIKE '%cross-network%' THEN 'Cross-network'
      WHEN (
        REGEXP_LIKE(t."TRAFFIC_SOURCE":"source"::STRING, 'alibaba|amazon|google shopping|shopify|etsy|ebay|stripe|walmart', 'i')
        OR REGEXP_LIKE(t."TRAFFIC_SOURCE":"campaign"::STRING, '^(.*(([^a-df-z]|^)shop|shopping).*)$', 'i')
      ) AND REGEXP_LIKE(t."TRAFFIC_SOURCE":"medium"::STRING, '^(.*cp.*|ppc|retargeting|paid.*)$', 'i') THEN 'Paid Shopping'
      WHEN REGEXP_LIKE(t."TRAFFIC_SOURCE":"source"::STRING, 'baidu|bing|duckduckgo|ecosia|google|yahoo|yandex', 'i')
           AND REGEXP_LIKE(t."TRAFFIC_SOURCE":"medium"::STRING, '^(.*cp.*|ppc|paid.*)$', 'i') THEN 'Paid Search'
      WHEN REGEXP_LIKE(t."TRAFFIC_SOURCE":"source"::STRING, 'badoo|facebook|fb|instagram|linkedin|pinterest|tiktok|twitter|whatsapp', 'i')
           AND REGEXP_LIKE(t."TRAFFIC_SOURCE":"medium"::STRING, '^(.*cp.*|ppc|retargeting|paid.*)$', 'i') THEN 'Paid Social'
      WHEN REGEXP_LIKE(t."TRAFFIC_SOURCE":"source"::STRING, 'dailymotion|disneyplus|netflix|youtube|vimeo|twitch', 'i')
           AND REGEXP_LIKE(t."TRAFFIC_SOURCE":"medium"::STRING, '^(.*cp.*|ppc|retargeting|paid.*)$', 'i') THEN 'Paid Video'
      WHEN t."TRAFFIC_SOURCE":"medium"::STRING IN ('display', 'banner', 'expandable', 'interstitial', 'cpm') THEN 'Display'
      WHEN (
        REGEXP_LIKE(t."TRAFFIC_SOURCE":"source"::STRING, 'alibaba|amazon|google shopping|shopify|etsy|ebay|stripe|walmart', 'i')
        OR REGEXP_LIKE(t."TRAFFIC_SOURCE":"campaign"::STRING, '^(.*(([^a-df-z]|^)shop|shopping).*)$', 'i')
      ) THEN 'Organic Shopping'
      WHEN REGEXP_LIKE(t."TRAFFIC_SOURCE":"source"::STRING, 'badoo|facebook|fb|instagram|linkedin|pinterest|tiktok|twitter|whatsapp', 'i')
           OR t."TRAFFIC_SOURCE":"medium"::STRING IN ('social', 'social-network', 'social-media', 'sm', 'social network', 'social media') THEN 'Organic Social'
      WHEN REGEXP_LIKE(t."TRAFFIC_SOURCE":"source"::STRING, 'dailymotion|disneyplus|netflix|youtube|vimeo|twitch', 'i')
           OR REGEXP_LIKE(t."TRAFFIC_SOURCE":"medium"::STRING, '^(.*video.*)$', 'i') THEN 'Organic Video'
      WHEN REGEXP_LIKE(t."TRAFFIC_SOURCE":"source"::STRING, 'baidu|bing|duckduckgo|ecosia|google|yahoo|yandex', 'i')
           OR t."TRAFFIC_SOURCE":"medium"::STRING = 'organic' THEN 'Organic Search'
      WHEN t."TRAFFIC_SOURCE":"medium"::STRING = 'referral' THEN 'Referral'
      WHEN t."TRAFFIC_SOURCE":"source"::STRING IN ('email', 'e-mail', 'e_mail', 'e mail')
           OR t."TRAFFIC_SOURCE":"medium"::STRING IN ('email', 'e-mail', 'e_mail', 'e mail') THEN 'Email'
      WHEN t."TRAFFIC_SOURCE":"medium"::STRING = 'affiliate' THEN 'Affiliates'
      WHEN t."TRAFFIC_SOURCE":"medium"::STRING = 'audio' THEN 'Audio'
      WHEN t."TRAFFIC_SOURCE":"source"::STRING = 'sms'
           OR t."TRAFFIC_SOURCE":"medium"::STRING = 'sms' THEN 'SMS'
      WHEN t."TRAFFIC_SOURCE":"medium"::STRING LIKE '%push'
           OR t."TRAFFIC_SOURCE":"medium"::STRING ILIKE '%mobile%'
           OR t."TRAFFIC_SOURCE":"medium"::STRING ILIKE '%notification%' THEN 'Mobile Push Notifications'
      ELSE 'Unassigned'
    END AS "Channel",
    f.VALUE:"value":"int_value"::INT AS "ga_session_id"
  FROM (
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201201
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201202
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201203
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201204
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201205
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201206
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201207
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201208
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201209
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201210
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201211
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201212
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201213
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201214
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201215
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201216
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201217
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201218
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201219
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201220
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201221
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201222
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201223
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201224
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201225
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201226
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201227
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201228
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201229
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201230
    UNION ALL
    SELECT * FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20201231
  ) t,
  LATERAL FLATTEN(input => t."EVENT_PARAMS") f
  WHERE t."EVENT_NAME" = 'session_start'
    AND f.VALUE:"key"::STRING = 'ga_session_id'
) s
GROUP BY s."Channel"
ORDER BY "Sessions" DESC NULLS LAST
LIMIT 1 OFFSET 3;