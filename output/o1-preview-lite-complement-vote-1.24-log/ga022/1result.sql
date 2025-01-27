WITH new_users AS (
  SELECT DISTINCT user_pseudo_id
  FROM (
    SELECT user_pseudo_id, user_first_touch_timestamp
    FROM (
      SELECT user_pseudo_id, user_first_touch_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180901`
      UNION ALL
      SELECT user_pseudo_id, user_first_touch_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180902`
      UNION ALL
      SELECT user_pseudo_id, user_first_touch_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180903`
      UNION ALL
      SELECT user_pseudo_id, user_first_touch_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180904`
      UNION ALL
      SELECT user_pseudo_id, user_first_touch_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180905`
      UNION ALL
      SELECT user_pseudo_id, user_first_touch_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180906`
      UNION ALL
      SELECT user_pseudo_id, user_first_touch_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180907`
    )
  )
  WHERE DATE(DATETIME(TIMESTAMP_MICROS(user_first_touch_timestamp), 'Asia/Shanghai')) BETWEEN '2018-09-01' AND '2018-09-07'
),

events_following_weeks AS (
  SELECT user_pseudo_id, DATETIME(TIMESTAMP_MICROS(event_timestamp), 'Asia/Shanghai') AS event_datetime_shanghai
  FROM (
    SELECT user_pseudo_id, event_timestamp
    FROM (
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180908`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180909`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180910`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180911`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180912`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180913`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180914`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180915`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180916`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180917`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180918`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180919`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180920`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180921`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180922`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180923`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180924`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180925`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180926`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180927`
      UNION ALL
      SELECT user_pseudo_id, event_timestamp
      FROM `firebase-public-project.analytics_153293282.events_20180928`
    )
  )
  WHERE user_pseudo_id IN (SELECT user_pseudo_id FROM new_users)
),

weekly_retention AS (
  SELECT 
    CASE 
      WHEN DATE(event_datetime_shanghai) BETWEEN '2018-09-08' AND '2018-09-14' THEN 'Week 1'
      WHEN DATE(event_datetime_shanghai) BETWEEN '2018-09-15' AND '2018-09-21' THEN 'Week 2'
      WHEN DATE(event_datetime_shanghai) BETWEEN '2018-09-22' AND '2018-09-28' THEN 'Week 3'
    END AS Week,
    COUNT(DISTINCT user_pseudo_id) AS Retained_Users
  FROM events_following_weeks
  WHERE DATE(event_datetime_shanghai) BETWEEN '2018-09-08' AND '2018-09-28'
  GROUP BY Week
)

SELECT 
  Week,
  ROUND((Retained_Users / (SELECT COUNT(DISTINCT user_pseudo_id) FROM new_users)) * 100, 4) AS Retention_Rate
FROM weekly_retention
ORDER BY Week