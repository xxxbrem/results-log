WITH all_events AS (
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180801
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180802
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180803
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180804
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180805
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180806
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180807
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180808
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180809
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180810
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180811
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180812
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180813
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180814
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180815
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180816
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180817
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180818
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180819
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180820
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180821
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180822
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180823
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180824
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180825
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180826
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180827
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180828
  UNION ALL
  SELECT "event_date", "event_timestamp", "event_name", "event_params", "user_pseudo_id", "user_first_touch_timestamp"
  FROM FIREBASE.ANALYTICS_153293282.EVENTS_20180829
),
initial_users AS (
  SELECT DISTINCT "user_pseudo_id",
    DATEADD('SECOND', "user_first_touch_timestamp"/1000000, '1970-01-01') AS "first_touch_time"
  FROM all_events
  WHERE DATEADD('SECOND', "user_first_touch_timestamp"/1000000, '1970-01-01') BETWEEN '2018-08-01' AND '2018-08-15'
),
initial_user_boards AS (
  SELECT DISTINCT e."user_pseudo_id", u."first_touch_time",
    f.value:"value"."string_value"::STRING AS "quickplay_event_type"
  FROM all_events e
  INNER JOIN initial_users u ON e."user_pseudo_id" = u."user_pseudo_id",
    LATERAL FLATTEN(input => e."event_params") f
  WHERE e."event_name" IN ('level_start_quickplay', 'level_end_quickplay', 'level_complete_quickplay', 'level_fail_quickplay', 'level_retry_quickplay', 'level_reset_quickplay')
    AND DATEADD('SECOND', e."event_timestamp"/1000000, '1970-01-01') BETWEEN u."first_touch_time" AND u."first_touch_time" + INTERVAL '7 DAY'
    AND f.value:"key"::STRING = 'board'
),
second_week_activity AS (
  SELECT DISTINCT u."user_pseudo_id"
  FROM all_events e
  INNER JOIN initial_users u ON e."user_pseudo_id" = u."user_pseudo_id"
  WHERE DATEADD('SECOND', e."event_timestamp"/1000000, '1970-01-01') BETWEEN u."first_touch_time" + INTERVAL '7 DAY' AND u."first_touch_time" + INTERVAL '14 DAY'
)
SELECT
  q."quickplay_event_type",
  ROUND((COUNT(DISTINCT CASE WHEN s."user_pseudo_id" IS NOT NULL THEN q."user_pseudo_id" END) / COUNT(DISTINCT q."user_pseudo_id")) * 100, 4) AS "second_week_retention_rate"
FROM initial_user_boards q
LEFT JOIN second_week_activity s ON q."user_pseudo_id" = s."user_pseudo_id"
GROUP BY q."quickplay_event_type"
ORDER BY "second_week_retention_rate" ASC NULLS LAST
LIMIT 1;