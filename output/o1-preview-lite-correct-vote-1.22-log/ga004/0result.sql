SELECT
  ROUND(
    AVG(IF(is_purchaser = 1, pageviews, NULL)) - AVG(IF(is_purchaser = 0, pageviews, NULL)),
    4
  ) AS Difference_in_Average_Pageviews
FROM (
  SELECT
    user_pseudo_id,
    COUNTIF(LOWER(event_name) = 'page_view') AS pageviews,
    MAX(IF(LOWER(event_name) = 'purchase', 1, 0)) AS is_purchaser
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_202012*`
  GROUP BY user_pseudo_id
)