WITH
  buyers AS (
    SELECT `event_date`, `user_pseudo_id`
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
      AND `event_name` = 'purchase'
    GROUP BY `event_date`, `user_pseudo_id`
  ),
  buyer_page_views AS (
    SELECT e.`event_date`, e.`user_pseudo_id`, COUNT(*) AS `page_views`
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS e
    JOIN buyers b ON e.`user_pseudo_id` = b.`user_pseudo_id` AND e.`event_date` = b.`event_date`
    WHERE e._TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
      AND e.`event_name` = 'page_view'
    GROUP BY e.`event_date`, e.`user_pseudo_id`
  )
SELECT
  FORMAT_DATE('%Y-%m-%d', PARSE_DATE('%Y%m%d', `event_date`)) AS `Date`,
  ROUND(AVG(`page_views`), 4) AS `Average_Page_Views_per_Buyer`,
  SUM(`page_views`) AS `Total_Page_Views`
FROM
  buyer_page_views
GROUP BY `Date`
ORDER BY `Date`;