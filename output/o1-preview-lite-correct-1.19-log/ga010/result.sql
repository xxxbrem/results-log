SELECT
  Channel,
  COUNT(*) AS Number_of_Sessions
FROM (
  SELECT
    CASE
      WHEN LOWER(traffic_source.source) = '(direct)' 
           AND (LOWER(traffic_source.medium) = '(not set)' OR LOWER(traffic_source.medium) = '(none)') THEN 'Direct'
      WHEN LOWER(traffic_source.name) LIKE '%cross-network%' THEN 'Cross-network'
      WHEN (
            REGEXP_CONTAINS(LOWER(traffic_source.source), r'(alibaba|amazon|google shopping|shopify|etsy|ebay|stripe|walmart)') 
            OR REGEXP_CONTAINS(LOWER(traffic_source.name), r'^(.*(([^a-df-z]|^)shop|shopping).*)$')
           )
           AND REGEXP_CONTAINS(LOWER(traffic_source.medium), r'^(.*cp.*|ppc|retargeting|paid.*)$') THEN 'Paid Shopping'
      WHEN REGEXP_CONTAINS(LOWER(traffic_source.source), r'(alibaba|amazon|google shopping|shopify|etsy|ebay|stripe|walmart)')
           OR REGEXP_CONTAINS(LOWER(traffic_source.name), r'^(.*(([^a-df-z]|^)shop|shopping).*)$') THEN 'Organic Shopping'
      WHEN REGEXP_CONTAINS(LOWER(traffic_source.source), r'(baidu|bing|duckduckgo|ecosia|google|yahoo|yandex)')
           AND REGEXP_CONTAINS(LOWER(traffic_source.medium), r'^(.*cp.*|ppc|paid.*)$') THEN 'Paid Search'
      WHEN REGEXP_CONTAINS(LOWER(traffic_source.source), r'(baidu|bing|duckduckgo|ecosia|google|yahoo|yandex)')
           OR LOWER(traffic_source.medium) = 'organic' THEN 'Organic Search'
      WHEN REGEXP_CONTAINS(LOWER(traffic_source.source), r'(badoo|facebook|fb|instagram|linkedin|pinterest|tiktok|twitter|whatsapp)')
           AND REGEXP_CONTAINS(LOWER(traffic_source.medium), r'^(.*cp.*|ppc|retargeting|paid.*)$') THEN 'Paid Social'
      WHEN REGEXP_CONTAINS(LOWER(traffic_source.source), r'(badoo|facebook|fb|instagram|linkedin|pinterest|tiktok|twitter|whatsapp)')
           OR LOWER(traffic_source.medium) IN ('social', 'social-network', 'social-media', 'sm', 'social network', 'social media') THEN 'Organic Social'
      WHEN REGEXP_CONTAINS(LOWER(traffic_source.source), r'(dailymotion|disneyplus|netflix|youtube|vimeo|twitch)')
           AND REGEXP_CONTAINS(LOWER(traffic_source.medium), r'^(.*cp.*|ppc|retargeting|paid.*)$') THEN 'Paid Video'
      WHEN REGEXP_CONTAINS(LOWER(traffic_source.source), r'(dailymotion|disneyplus|netflix|youtube|vimeo|twitch)')
           OR REGEXP_CONTAINS(LOWER(traffic_source.medium), r'.*video.*') THEN 'Organic Video'
      WHEN LOWER(traffic_source.medium) IN ('display', 'banner', 'expandable', 'interstitial', 'cpm') THEN 'Display'
      WHEN LOWER(traffic_source.medium) = 'referral' THEN 'Referral'
      WHEN LOWER(traffic_source.source) IN ('email', 'e-mail', 'e_mail', 'e mail') 
           OR LOWER(traffic_source.medium) IN ('email', 'e-mail', 'e_mail', 'e mail') THEN 'Email'
      WHEN LOWER(traffic_source.medium) = 'affiliate' THEN 'Affiliates'
      WHEN LOWER(traffic_source.medium) = 'audio' THEN 'Audio'
      WHEN LOWER(traffic_source.medium) = 'sms' OR LOWER(traffic_source.source) = 'sms' THEN 'SMS'
      WHEN REGEXP_CONTAINS(LOWER(traffic_source.medium), r'push$')
           OR REGEXP_CONTAINS(LOWER(traffic_source.medium), r'(mobile|notification)') THEN 'Mobile Push Notifications'
      ELSE 'Unassigned'
    END AS Channel
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    `_TABLE_SUFFIX` BETWEEN '20201201' AND '20201231'
    AND event_name = 'session_start'
)
GROUP BY Channel
ORDER BY Number_of_Sessions DESC