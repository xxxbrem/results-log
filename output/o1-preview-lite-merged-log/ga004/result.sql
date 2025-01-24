WITH user_pageviews AS (
  SELECT
    user_pseudo_id,
    SUM(CASE WHEN LOWER(event_name) = 'page_view' THEN 1 ELSE 0 END) AS pageviews,
    MAX(CASE WHEN LOWER(event_name) = 'purchase' THEN 1 ELSE 0 END) AS is_purchaser
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_202012*`
  GROUP BY user_pseudo_id
),
averages AS (
  SELECT
    AVG(CASE WHEN is_purchaser = 1 THEN pageviews ELSE NULL END) AS avg_pageviews_purchasers,
    AVG(CASE WHEN is_purchaser = 0 THEN pageviews ELSE NULL END) AS avg_pageviews_nonpurchasers
  FROM user_pageviews
)
SELECT
  ROUND(avg_pageviews_purchasers - avg_pageviews_nonpurchasers, 4) AS Difference_in_Average_Pageviews
FROM averages;