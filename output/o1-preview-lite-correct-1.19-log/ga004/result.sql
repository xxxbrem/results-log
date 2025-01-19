WITH unioned_events AS (
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
),
purchasers AS (
  SELECT DISTINCT user_pseudo_id
  FROM unioned_events
  WHERE event_name = 'purchase'
),
user_pageviews AS (
  SELECT user_pseudo_id,
    SUM(CASE WHEN event_name = 'page_view' THEN 1 ELSE 0 END) AS pageviews
  FROM unioned_events
  GROUP BY user_pseudo_id
),
labeled_user_pageviews AS (
  SELECT up.user_pseudo_id, up.pageviews,
    CASE WHEN p.user_pseudo_id IS NOT NULL THEN 'purchaser' ELSE 'non_purchaser' END AS purchaser_status
  FROM user_pageviews up
  LEFT JOIN purchasers p
  ON up.user_pseudo_id = p.user_pseudo_id
)
SELECT
  ROUND(
    AVG(CASE WHEN purchaser_status = 'purchaser' THEN pageviews END) -
    AVG(CASE WHEN purchaser_status = 'non_purchaser' THEN pageviews END),
    4
  ) AS difference
FROM labeled_user_pageviews;