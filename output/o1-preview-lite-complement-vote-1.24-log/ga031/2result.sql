WITH sessions AS (
  SELECT
    user_pseudo_id,
    (SELECT CAST(value.int_value AS STRING) FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS ga_session_id,
    event_timestamp,
    event_name,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'page_title') AS page_title
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102`
),
session_first_events AS (
  SELECT
    user_pseudo_id,
    ga_session_id,
    MIN(event_timestamp) AS session_start_timestamp
  FROM sessions
  GROUP BY user_pseudo_id, ga_session_id
),
session_start_page AS (
  SELECT
    sfe.user_pseudo_id,
    sfe.ga_session_id,
    sfe.session_start_timestamp,
    s.event_name AS first_event_name,
    s.page_title AS first_page_title
  FROM session_first_events sfe
  JOIN sessions s
    ON sfe.user_pseudo_id = s.user_pseudo_id
    AND sfe.ga_session_id = s.ga_session_id
    AND sfe.session_start_timestamp = s.event_timestamp
),
sessions_with_home_landing AS (
  SELECT DISTINCT
    user_pseudo_id,
    ga_session_id
  FROM session_start_page
  WHERE first_event_name = 'page_view' AND first_page_title = 'Home'
),
sessions_with_checkout_confirmation AS (
  SELECT DISTINCT
    user_pseudo_id,
    ga_session_id
  FROM sessions
  WHERE page_title = 'Checkout Confirmation'
),
sessions_landed_home_and_reached_checkout AS (
  SELECT
    shl.user_pseudo_id,
    shl.ga_session_id
  FROM sessions_with_home_landing shl
  INNER JOIN sessions_with_checkout_confirmation swcc
    ON shl.user_pseudo_id = swcc.user_pseudo_id
    AND shl.ga_session_id = swcc.ga_session_id
)
SELECT
  ROUND(
    (SELECT COUNT(*) FROM sessions_landed_home_and_reached_checkout) * 100.0 /
    (SELECT COUNT(*) FROM sessions_with_home_landing),
    4
  ) AS conversion_rate;