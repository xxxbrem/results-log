SELECT COUNT(*) AS number_of_pseudo_users
FROM (
  SELECT DISTINCT user_pseudo_id
  FROM (
    SELECT user_pseudo_id FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210101`
    UNION ALL
    SELECT user_pseudo_id FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102`
    UNION ALL
    SELECT user_pseudo_id FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210103`
    UNION ALL
    SELECT user_pseudo_id FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210104`
    UNION ALL
    SELECT user_pseudo_id FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210105`
  )
  EXCEPT DISTINCT
  SELECT DISTINCT user_pseudo_id
  FROM (
    SELECT user_pseudo_id FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210106`
    UNION ALL
    SELECT user_pseudo_id FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210107`
  )
) AS result;