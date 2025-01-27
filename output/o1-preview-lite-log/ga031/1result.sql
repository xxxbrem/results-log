WITH first_page_views AS (
  SELECT
    t.user_pseudo_id,
    t.event_timestamp,
    ep.value.string_value AS page_title,
    ROW_NUMBER() OVER (PARTITION BY t.user_pseudo_id ORDER BY t.event_timestamp ASC) AS rn
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102` AS t,
    UNNEST(t.event_params) AS ep
  WHERE
    t.event_name = 'page_view' AND ep.key = 'page_title'
),
home_landing_sessions AS (
  SELECT user_pseudo_id
  FROM first_page_views
  WHERE rn = 1 AND page_title = 'Home'
),
checkout_sessions AS (
  SELECT DISTINCT t.user_pseudo_id
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102` AS t,
  UNNEST(t.event_params) AS ep
  WHERE
    t.event_name = 'page_view' AND ep.key = 'page_title' AND ep.value.string_value = 'Checkout Confirmation'
),
converted_sessions AS (
  SELECT user_pseudo_id
  FROM home_landing_sessions
  WHERE user_pseudo_id IN (SELECT user_pseudo_id FROM checkout_sessions)
)
SELECT
  ROUND(100.0 * COUNT(converted_sessions.user_pseudo_id) / COUNT(home_landing_sessions.user_pseudo_id), 4) AS conversion_rate
FROM
  home_landing_sessions
LEFT JOIN
  converted_sessions USING (user_pseudo_id);