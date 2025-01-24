WITH events AS (
  SELECT
    PARSE_DATE('%Y%m%d', event_date) AS Date,
    user_pseudo_id,
    event_name
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
),
buyers AS (
  SELECT DISTINCT Date, user_pseudo_id
  FROM events
  WHERE event_name = 'purchase'
),
page_views_per_buyer AS (
  SELECT
    b.Date,
    b.user_pseudo_id,
    COUNTIF(e.event_name = 'page_view') AS page_view_count
  FROM buyers b
  LEFT JOIN events e
    ON b.Date = e.Date AND b.user_pseudo_id = e.user_pseudo_id
  GROUP BY b.Date, b.user_pseudo_id
),
summary AS (
  SELECT
    Date,
    COUNT(DISTINCT user_pseudo_id) AS buyer_count,
    SUM(page_view_count) AS total_page_views,
    AVG(page_view_count) AS avg_page_views_per_buyer
  FROM page_views_per_buyer
  GROUP BY Date
)
SELECT
  FORMAT_DATE('%Y-%m-%d', Date) AS Date,
  ROUND(avg_page_views_per_buyer, 4) AS Average_Page_Views_per_Buyer,
  total_page_views AS Total_Page_Views
FROM summary
ORDER BY Date;