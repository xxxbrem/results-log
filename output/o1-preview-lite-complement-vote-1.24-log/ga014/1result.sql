SELECT 
  channel,
  COUNT(DISTINCT session_id) AS number_of_sessions
FROM (
  SELECT
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    traffic_source.name AS campaign_name,
    CASE
      WHEN traffic_source.source = '(direct)' AND traffic_source.medium IN ('(not set)', '(none)') THEN 'Direct'
      WHEN LOWER(traffic_source.name) LIKE '%cross-network%' THEN 'Cross-network'
      WHEN (
            traffic_source.source IN ('alibaba', 'amazon', 'google shopping', 'shopify', 'etsy', 'ebay', 'stripe', 'walmart') OR
            LOWER(traffic_source.name) LIKE '%shop%' OR LOWER(traffic_source.name) LIKE '%shopping%'
          )
          AND 
          (
            traffic_source.medium LIKE '%cp%' OR 
            traffic_source.medium IN ('ppc', 'retargeting') OR 
            LOWER(traffic_source.medium) LIKE 'paid%'
          ) THEN 'Paid Shopping'
      WHEN traffic_source.source IN ('baidu','bing','duckduckgo','ecosia','google','yahoo','yandex') 
           AND 
           (
             traffic_source.medium LIKE '%cp%' OR 
             traffic_source.medium IN ('ppc', 'retargeting') OR 
             LOWER(traffic_source.medium) LIKE 'paid%'
           ) THEN 'Paid Search'
      WHEN traffic_source.source IN ('badoo','facebook','fb','instagram','linkedin','pinterest','tiktok','twitter','whatsapp') 
           AND 
           (
             traffic_source.medium LIKE '%cp%' OR 
             traffic_source.medium IN ('ppc', 'retargeting') OR 
             LOWER(traffic_source.medium) LIKE 'paid%'
           ) THEN 'Paid Social'
      WHEN traffic_source.source IN ('dailymotion','disneyplus','netflix','youtube','vimeo','twitch') 
           AND 
           (
             traffic_source.medium LIKE '%cp%' OR 
             traffic_source.medium IN ('ppc', 'retargeting') OR 
             LOWER(traffic_source.medium) LIKE 'paid%'
           ) THEN 'Paid Video'
      WHEN traffic_source.medium IN ('display', 'banner', 'expandable', 'interstitial', 'cpm') THEN 'Display'
      WHEN (
            traffic_source.source IN ('alibaba', 'amazon', 'google shopping', 'shopify', 'etsy', 'ebay', 'stripe', 'walmart') OR
            LOWER(traffic_source.name) LIKE '%shop%' OR LOWER(traffic_source.name) LIKE '%shopping%'
          ) THEN 'Organic Shopping'
      WHEN 
          traffic_source.source IN ('badoo','facebook','fb','instagram','linkedin','pinterest','tiktok','twitter','whatsapp') 
          OR 
          traffic_source.medium IN ('social', 'social-network', 'social-media', 'sm', 'social network', 'social media') THEN 'Organic Social'
      WHEN 
          traffic_source.source IN ('dailymotion','disneyplus','netflix','youtube','vimeo','twitch') 
          OR 
          LOWER(traffic_source.medium) LIKE '%video%' THEN 'Organic Video'
      WHEN 
          traffic_source.source IN ('baidu','bing','duckduckgo','ecosia','google','yahoo','yandex') 
          OR 
          traffic_source.medium = 'organic' THEN 'Organic Search'
      WHEN traffic_source.medium = 'referral' THEN 'Referral'
      WHEN traffic_source.source IN ('email','e-mail','e_mail','e mail') OR traffic_source.medium IN ('email','e-mail','e_mail','e mail') THEN 'Email'
      WHEN traffic_source.medium = 'affiliate' THEN 'Affiliates'
      WHEN traffic_source.medium = 'audio' THEN 'Audio'
      WHEN traffic_source.source = 'sms' OR traffic_source.medium = 'sms' THEN 'SMS'
      WHEN ENDS_WITH(traffic_source.medium, 'push') OR LOWER(traffic_source.medium) LIKE '%mobile%' OR LOWER(traffic_source.medium) LIKE '%notification%' THEN 'Mobile Push Notifications'
      ELSE 'Unassigned'
    END AS channel
  FROM (
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201201`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201202`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201203`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201204`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201205`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201206`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201207`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201208`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201209`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201210`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201211`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201212`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201213`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201214`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201215`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201216`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201217`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201218`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201219`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201220`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201221`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201222`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201223`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201224`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201225`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201226`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201227`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201228`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201229`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201230`
    UNION ALL
    SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201231`
  ) AS all_events
  WHERE
    event_name = 'session_start'
)
GROUP BY
  channel
ORDER BY
  number_of_sessions DESC;