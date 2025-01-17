SELECT
    channel,
    "SESSION_COUNT"
FROM (
    SELECT
        CASE
            WHEN source = '(direct)' AND (medium = '(not set)' OR medium = '(none)') THEN 'Direct'
            WHEN LOWER(campaign) LIKE '%cross-network%' THEN 'Cross-network'
            WHEN (
                source IN ('alibaba', 'amazon', 'google shopping', 'shopify', 'etsy', 'ebay', 'stripe', 'walmart')
                OR REGEXP_LIKE(campaign, '^(.*(([^a-df-z]|^)shop|shopping).*)$')
            ) AND REGEXP_LIKE(medium, '^(.*cp.*|ppc|retargeting|paid.*)$') THEN 'Paid Shopping'
            WHEN source IN ('baidu', 'bing', 'duckduckgo', 'ecosia', 'google', 'yahoo', 'yandex') AND REGEXP_LIKE(medium, '^(.*cp.*|ppc|paid.*)$') THEN 'Paid Search'
            WHEN REGEXP_LIKE(source, '(badoo|facebook|fb|instagram|linkedin|pinterest|tiktok|twitter|whatsapp)') AND REGEXP_LIKE(medium, '^(.*cp.*|ppc|retargeting|paid.*)$') THEN 'Paid Social'
            WHEN source IN ('dailymotion', 'disneyplus', 'netflix', 'youtube', 'vimeo', 'twitch') AND REGEXP_LIKE(medium, '^(.*cp.*|ppc|retargeting|paid.*)$') THEN 'Paid Video'
            WHEN medium IN ('display', 'banner', 'expandable', 'interstitial', 'cpm') THEN 'Display'
            WHEN (
                source IN ('alibaba', 'amazon', 'google shopping', 'shopify', 'etsy', 'ebay', 'stripe', 'walmart')
                OR REGEXP_LIKE(campaign, '^(.*(([^a-df-z]|^)shop|shopping).*)$')
            ) THEN 'Organic Shopping'
            WHEN REGEXP_LIKE(source, '(badoo|facebook|fb|instagram|linkedin|pinterest|tiktok|twitter|whatsapp)')
                 OR medium IN ('social', 'social-network', 'social-media', 'sm', 'social network', 'social media') THEN 'Organic Social'
            WHEN source IN ('dailymotion', 'disneyplus', 'netflix', 'youtube', 'vimeo', 'twitch')
                 OR REGEXP_LIKE(medium, '^(.*video.*)$') THEN 'Organic Video'
            WHEN source IN ('baidu', 'bing', 'duckduckgo', 'ecosia', 'google', 'yahoo', 'yandex') OR medium = 'organic' THEN 'Organic Search'
            WHEN medium = 'referral' THEN 'Referral'
            WHEN source IN ('email', 'e-mail', 'e_mail', 'e mail') OR medium IN ('email', 'e-mail', 'e_mail', 'e mail') THEN 'Email'
            WHEN medium = 'affiliate' THEN 'Affiliates'
            WHEN medium = 'audio' THEN 'Audio'
            WHEN source = 'sms' OR medium = 'sms' THEN 'SMS'
            WHEN medium LIKE '%push' OR medium LIKE '%mobile%' OR medium LIKE '%notification%' THEN 'Mobile Push Notifications'
            ELSE 'Unassigned'
        END AS channel,
        COUNT(DISTINCT "USER_PSEUDO_ID") AS "SESSION_COUNT"
    FROM (
        SELECT
            "EVENT_NAME",
            "USER_PSEUDO_ID",
            LOWER(COALESCE("TRAFFIC_SOURCE":source::STRING, '(not set)')) AS source,
            LOWER(COALESCE("TRAFFIC_SOURCE":medium::STRING, '(not set)')) AS medium,
            LOWER(COALESCE("TRAFFIC_SOURCE":campaign::STRING, '(not set)')) AS campaign
        FROM (
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201201"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201202"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201203"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201204"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201205"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201206"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201207"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201208"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201209"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201210"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201211"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201212"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201213"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201214"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201215"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201216"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201217"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201218"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201219"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201220"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201221"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201222"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201223"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201224"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201225"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201226"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201227"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201228"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201229"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201230"
            UNION ALL
            SELECT "EVENT_NAME", "TRAFFIC_SOURCE", "USER_PSEUDO_ID"
            FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201231"
        ) t
        WHERE "EVENT_NAME" = 'session_start'
    ) session_events
    GROUP BY channel
) channel_sessions
ORDER BY "SESSION_COUNT" DESC NULLS LAST
LIMIT 1 OFFSET 3;