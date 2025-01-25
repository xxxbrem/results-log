WITH home_sessions AS (
  SELECT
    session_id
  FROM (
    SELECT
      ep_session.value.int_value AS session_id,
      ep_page.value.string_value AS page_title,
      t.event_timestamp,
      ROW_NUMBER() OVER (PARTITION BY ep_session.value.int_value ORDER BY t.event_timestamp ASC) AS event_rank
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102` t
    JOIN UNNEST(t.event_params) AS ep_session ON ep_session.key = 'ga_session_id'
    JOIN UNNEST(t.event_params) AS ep_page ON ep_page.key = 'page_title'
    WHERE ep_session.value.int_value IS NOT NULL
      AND ep_page.value.string_value IS NOT NULL
  )
  WHERE event_rank = 1 AND page_title = 'Home'
),

cc_sessions AS (
  SELECT DISTINCT ep_session.value.int_value AS session_id
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102` t
  JOIN UNNEST(t.event_params) AS ep_session ON ep_session.key = 'ga_session_id'
  JOIN UNNEST(t.event_params) AS ep_page ON ep_page.key = 'page_title'
  WHERE ep_session.value.int_value IS NOT NULL
    AND ep_page.value.string_value = 'Checkout Confirmation'
)

SELECT
  ROUND(
    SAFE_MULTIPLY(
      SAFE_DIVIDE(
        (SELECT COUNT(DISTINCT hs.session_id)
         FROM home_sessions hs
         JOIN cc_sessions cs ON hs.session_id = cs.session_id),
        (SELECT COUNT(*) FROM home_sessions)
      ),
      100
    ), 4
  ) AS conversion_rate;