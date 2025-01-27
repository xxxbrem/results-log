WITH session_data AS (
  SELECT
    CAST(ep.value.int_value AS INT64) AS ga_session_id,
    COALESCE(LOWER(t.traffic_source.medium), '(none)') AS medium,
    COALESCE(LOWER(t.traffic_source.source), '(direct)') AS source,
    COALESCE(LOWER(t.traffic_source.name), '(not set)') AS campaign_name
  FROM (
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201201` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201202` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201203` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201204` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201205` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201206` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201207` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201208` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201209` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201210` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201211` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201212` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201213` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201214` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201215` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201216` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201217` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201218` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201219` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201220` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201221` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201222` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201223` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201224` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201225` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201226` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201227` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201228` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201229` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201230` UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201231`
  ) AS t
  LEFT JOIN UNNEST(t.event_params) AS ep
    ON ep.key = 'ga_session_id'
  WHERE t.event_name = 'session_start' AND ep.value.int_value IS NOT NULL
)

SELECT 
  Channel, 
  COUNT(DISTINCT ga_session_id) AS Number_of_Sessions
FROM (
  SELECT
    ga_session_id,
    medium,
    source,
    campaign_name,
    CASE
      WHEN source = '(direct)' AND medium IN ('(not set)', '(none)') THEN 'Direct'
      WHEN campaign_name LIKE '%cross-network%' THEN 'Cross-network'
      WHEN medium IN ('cpc', 'ppc', 'retargeting', 'paidsearch') AND source IN ('google', 'bing', 'baidu', 'yahoo', 'yandex', 'duckduckgo', 'ecosia') THEN 'Paid Search'
      WHEN medium IN ('cpc', 'ppc', 'retargeting', 'paidshopping') AND source IN ('alibaba', 'amazon', 'ebay', 'etsy', 'shopify', 'stripe', 'walmart') THEN 'Paid Shopping'
      WHEN medium IN ('cpc', 'ppc', 'retargeting', 'paidsocial') AND source IN ('badoo', 'facebook', 'fb', 'instagram', 'linkedin', 'pinterest', 'tiktok', 'twitter', 'whatsapp') THEN 'Paid Social'
      WHEN medium IN ('cpc', 'ppc', 'retargeting', 'paidvideo') AND source IN ('dailymotion', 'disneyplus', 'netflix', 'twitch', 'vimeo', 'youtube') THEN 'Paid Video'
      WHEN medium IN ('display', 'banner', 'expandable', 'interstitial', 'cpm') THEN 'Display'
      WHEN source IN ('alibaba', 'amazon', 'ebay', 'etsy', 'shopify', 'stripe', 'walmart') OR campaign_name LIKE '%shop%' OR campaign_name LIKE '%shopping%' THEN 'Organic Shopping'
      WHEN medium IN ('social', 'social-network', 'social-media', 'sm', 'social network', 'social media') OR source IN ('badoo', 'facebook', 'fb', 'instagram', 'linkedin', 'pinterest', 'tiktok', 'twitter', 'whatsapp') THEN 'Organic Social'
      WHEN source IN ('dailymotion', 'disneyplus', 'netflix', 'twitch', 'vimeo', 'youtube') OR medium LIKE '%video%' THEN 'Organic Video'
      WHEN source IN ('baidu', 'bing', 'duckduckgo', 'ecosia', 'google', 'yahoo', 'yandex') OR medium = 'organic' THEN 'Organic Search'
      WHEN medium = 'referral' THEN 'Referral'
      WHEN medium IN ('email', 'e-mail', 'e_mail', 'e mail') OR source IN ('email', 'e-mail', 'e_mail', 'e mail') THEN 'Email'
      WHEN medium = 'affiliate' THEN 'Affiliates'
      WHEN medium = 'audio' OR source = 'audio' THEN 'Audio'
      WHEN medium = 'sms' OR source = 'sms' THEN 'SMS'
      WHEN medium LIKE '%push' OR medium LIKE '%mobile%' OR medium LIKE '%notification%' THEN 'Mobile Push Notifications'
      ELSE 'Unassigned'
    END AS Channel
  FROM session_data
)
GROUP BY Channel
ORDER BY Number_of_Sessions DESC;