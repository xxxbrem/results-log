WITH all_events AS (
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180702`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180703`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180704`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180705`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180706`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180707`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180708`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180709`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180710`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180711`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180712`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180713`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180714`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180715`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180716`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180717`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180718`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180719`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180720`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180721`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180722`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180723`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180724`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180725`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180726`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180727`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180728`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180729`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180730`
  UNION ALL
  SELECT * FROM `firebase-public-project.analytics_153293282.events_20180731`
),

initial_events AS (
  SELECT
    user_pseudo_id,
    MIN(event_timestamp) AS initial_event_timestamp,
    event_name AS quickplay_event_type
  FROM
    all_events
  WHERE
    event_name IN (
      'level_start_quickplay',
      'level_complete_quickplay',
      'level_fail_quickplay',
      'level_retry_quickplay',
      'level_reset_quickplay',
      'level_end_quickplay'
    )
    AND event_date BETWEEN '20180702' AND '20180716'
  GROUP BY
    user_pseudo_id,
    event_name
),

retained_users AS (
  SELECT DISTINCT
    ie.user_pseudo_id,
    ie.quickplay_event_type
  FROM
    initial_events ie
  JOIN
    all_events e
  ON
    ie.user_pseudo_id = e.user_pseudo_id
  WHERE
    TIMESTAMP_MICROS(e.event_timestamp) >= TIMESTAMP_ADD(TIMESTAMP_MICROS(ie.initial_event_timestamp), INTERVAL 14 DAY)
    AND TIMESTAMP_MICROS(e.event_timestamp) < TIMESTAMP_ADD(TIMESTAMP_MICROS(ie.initial_event_timestamp), INTERVAL 21 DAY)
    AND e.event_timestamp != ie.initial_event_timestamp
)

SELECT
  ie.quickplay_event_type AS Quickplay_Event_Type,
  ROUND(COUNT(DISTINCT ru.user_pseudo_id) * 100.0 / COUNT(DISTINCT ie.user_pseudo_id), 4) AS Retention_Rate
FROM
  initial_events ie
LEFT JOIN
  retained_users ru ON ie.user_pseudo_id = ru.user_pseudo_id
  AND ie.quickplay_event_type = ru.quickplay_event_type
GROUP BY
  Quickplay_Event_Type
ORDER BY
  Retention_Rate DESC