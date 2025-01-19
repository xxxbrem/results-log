SELECT COUNT(DISTINCT user_pseudo_id) AS Number_of_pseudo_users
FROM (
  SELECT user_pseudo_id
  FROM (
    SELECT DISTINCT user_pseudo_id
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210101`
    UNION DISTINCT
    SELECT DISTINCT user_pseudo_id
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102`
    UNION DISTINCT
    SELECT DISTINCT user_pseudo_id
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210103`
    UNION DISTINCT
    SELECT DISTINCT user_pseudo_id
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210104`
    UNION DISTINCT
    SELECT DISTINCT user_pseudo_id
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210105`
  ) AS active_first_5_days
  WHERE user_pseudo_id NOT IN (
    SELECT user_pseudo_id
    FROM (
      SELECT DISTINCT user_pseudo_id
      FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210106`
      UNION DISTINCT
      SELECT DISTINCT user_pseudo_id
      FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210107`
    ) AS active_last_2_days
  )
)