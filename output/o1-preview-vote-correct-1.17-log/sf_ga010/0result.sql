SELECT
    "Channel",
    "Number of Sessions"
FROM (
    SELECT
        "Channel",
        COUNT(*) AS "Number of Sessions",
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC NULLS LAST) AS rn
    FROM (
        SELECT
            CASE
                WHEN COALESCE(t."TRAFFIC_SOURCE":source::STRING, '') = '(direct)'
                     AND COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') IN ('(not set)', '(none)', '') THEN 'Direct'
                WHEN COALESCE(t."TRAFFIC_SOURCE":campaign::STRING, '') ILIKE '%cross-network%' THEN 'Cross-network'
                WHEN COALESCE(t."TRAFFIC_SOURCE":source::STRING, '') IN ('alibaba','amazon','google shopping','shopify','etsy','ebay','stripe','walmart')
                     OR COALESCE(t."TRAFFIC_SOURCE":campaign::STRING, '') REGEXP '^(.*\\b(shop|shopping)\\b.*)$'
                     AND COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') REGEXP '^(.*cp.*|ppc|retargeting|paid.*)$' THEN 'Paid Shopping'
                WHEN COALESCE(t."TRAFFIC_SOURCE":source::STRING, '') IN ('baidu','bing','duckduckgo','ecosia','google','yahoo','yandex')
                     AND COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') REGEXP '^(.*cp.*|ppc|paid.*)$' THEN 'Paid Search'
                WHEN COALESCE(t."TRAFFIC_SOURCE":source::STRING, '') REGEXP '(badoo|facebook|fb|instagram|linkedin|pinterest|tiktok|twitter|whatsapp)'
                     AND COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') REGEXP '^(.*cp.*|ppc|retargeting|paid.*)$' THEN 'Paid Social'
                WHEN COALESCE(t."TRAFFIC_SOURCE":source::STRING, '') IN ('dailymotion','disneyplus','netflix','youtube','vimeo','twitch')
                     AND COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') REGEXP '^(.*cp.*|ppc|retargeting|paid.*)$' THEN 'Paid Video'
                WHEN COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') IN ('display','banner','expandable','interstitial','cpm') THEN 'Display'
                WHEN COALESCE(t."TRAFFIC_SOURCE":source::STRING, '') IN ('alibaba','amazon','google shopping','shopify','etsy','ebay','stripe','walmart')
                     OR COALESCE(t."TRAFFIC_SOURCE":campaign::STRING, '') REGEXP '^(.*\\b(shop|shopping)\\b.*)$' THEN 'Organic Shopping'
                WHEN COALESCE(t."TRAFFIC_SOURCE":source::STRING, '') REGEXP '(badoo|facebook|fb|instagram|linkedin|pinterest|tiktok|twitter|whatsapp)'
                     OR COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') IN ('social','social-network','social-media','sm','social network','social media') THEN 'Organic Social'
                WHEN COALESCE(t."TRAFFIC_SOURCE":source::STRING, '') IN ('dailymotion','disneyplus','netflix','youtube','vimeo','twitch')
                     OR COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') REGEXP '^(.*video.*)$' THEN 'Organic Video'
                WHEN COALESCE(t."TRAFFIC_SOURCE":source::STRING, '') IN ('baidu','bing','duckduckgo','ecosia','google','yahoo','yandex')
                     OR COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') = 'organic' THEN 'Organic Search'
                WHEN COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') = 'referral' THEN 'Referral'
                WHEN COALESCE(t."TRAFFIC_SOURCE":source::STRING, '') IN ('email','e-mail','e_mail','e mail')
                     OR COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') IN ('email','e-mail','e_mail','e mail') THEN 'Email'
                WHEN COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') = 'affiliate' THEN 'Affiliates'
                WHEN COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') = 'audio' THEN 'Audio'
                WHEN COALESCE(t."TRAFFIC_SOURCE":source::STRING, '') = 'sms'
                     OR COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') = 'sms' THEN 'SMS'
                WHEN RIGHT(COALESCE(t."TRAFFIC_SOURCE":medium::STRING, ''), 4) = 'push'
                     OR COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') ILIKE '%mobile%'
                     OR COALESCE(t."TRAFFIC_SOURCE":medium::STRING, '') ILIKE '%notification%' THEN 'Mobile Push Notifications'
                ELSE 'Unassigned'
            END AS "Channel"
        FROM (
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201201"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201202"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201203"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201204"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201205"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201206"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201207"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201208"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201209"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201210"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201211"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201212"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201213"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201214"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201215"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201216"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201217"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201218"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201219"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201220"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201221"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201222"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201223"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201224"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201225"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201226"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201227"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201228"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201229"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201230"
            UNION ALL
            SELECT * FROM "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20201231"
        ) AS t
        WHERE t."EVENT_NAME" = 'session_start'
    ) AS sessions
    GROUP BY "Channel"
) AS ordered_channels
WHERE rn = 4;