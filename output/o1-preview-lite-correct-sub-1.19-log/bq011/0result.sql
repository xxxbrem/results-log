WITH last_7_days_users AS (
  SELECT DISTINCT `user_pseudo_id`
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210101`
  UNION DISTINCT
  SELECT DISTINCT `user_pseudo_id`
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102`
  UNION DISTINCT
  SELECT DISTINCT `user_pseudo_id`
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210103`
  UNION DISTINCT
  SELECT DISTINCT `user_pseudo_id`
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210104`
  UNION DISTINCT
  SELECT DISTINCT `user_pseudo_id`
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210105`
),
last_2_days_users AS (
  SELECT DISTINCT `user_pseudo_id`
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210106`
  UNION DISTINCT
  SELECT DISTINCT `user_pseudo_id`
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210107`
)
SELECT COUNT(*) AS number_of_pseudo_users
FROM (
  SELECT `user_pseudo_id` FROM last_7_days_users
  EXCEPT DISTINCT
  SELECT `user_pseudo_id` FROM last_2_days_users
);