WITH initial_events AS (
  SELECT
    user_pseudo_id,
    event_name AS quickplay_event_type,
    MIN(event_date) AS first_event_date
  FROM
    `firebase-public-project.analytics_153293282.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20180702' AND '20180716'
    AND event_name IN (
      'level_complete_quickplay',
      'level_end_quickplay',
      'level_fail_quickplay',
      'level_reset_quickplay',
      'level_retry_quickplay',
      'level_start_quickplay'
    )
  GROUP BY
    user_pseudo_id,
    quickplay_event_type
),
retention AS (
  SELECT
    initial.quickplay_event_type,
    initial.user_pseudo_id,
    CASE
      WHEN COUNTIF(e.user_pseudo_id IS NOT NULL) > 0 THEN 1
      ELSE 0
    END AS retained
  FROM
    initial_events AS initial
  LEFT JOIN
    `firebase-public-project.analytics_153293282.events_*` AS e
  ON
    initial.user_pseudo_id = e.user_pseudo_id
    AND _TABLE_SUFFIX BETWEEN '20180717' AND '20180806'
    AND DATE_DIFF(
      PARSE_DATE('%Y%m%d', e.event_date),
      PARSE_DATE('%Y%m%d', initial.first_event_date),
      DAY
    ) BETWEEN 14 AND 21
  GROUP BY
    initial.quickplay_event_type,
    initial.user_pseudo_id
)
SELECT
  quickplay_event_type AS Quickplay_Event_Type,
  ROUND(AVG(retained) * 100, 4) AS Retention_Rate
FROM
  retention
GROUP BY
  quickplay_event_type
ORDER BY
  quickplay_event_type;