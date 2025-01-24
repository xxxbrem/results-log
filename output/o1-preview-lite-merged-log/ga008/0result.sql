WITH purchases AS (
  SELECT DISTINCT event_date, user_pseudo_id
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    `_TABLE_SUFFIX` BETWEEN '20201101' AND '20201130'
    AND event_name = 'purchase'
),
page_views AS (
  SELECT event_date, user_pseudo_id, COUNT(*) AS page_view_count
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    `_TABLE_SUFFIX` BETWEEN '20201101' AND '20201130'
    AND event_name = 'page_view'
  GROUP BY event_date, user_pseudo_id
),
buyer_page_views AS (
  SELECT
    p.event_date,
    p.user_pseudo_id,
    IFNULL(pv.page_view_count, 0) AS page_views
  FROM purchases p
  LEFT JOIN page_views pv
    ON p.event_date = pv.event_date AND p.user_pseudo_id = pv.user_pseudo_id
)
SELECT
  FORMAT_DATE('%Y-%m-%d', PARSE_DATE('%Y%m%d', event_date)) AS Date,
  ROUND(AVG(page_views), 4) AS Average_Page_Views_per_Buyer,
  SUM(page_views) AS Total_Page_Views
FROM buyer_page_views
GROUP BY Date
ORDER BY Date