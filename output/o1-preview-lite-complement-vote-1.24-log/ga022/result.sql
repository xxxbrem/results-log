WITH new_users AS (
    SELECT DISTINCT `user_pseudo_id`
    FROM `firebase-public-project.analytics_153293282.events_*`
    WHERE
        _TABLE_SUFFIX BETWEEN '20180901' AND '20180907'
        AND DATETIME(TIMESTAMP_MICROS(`user_first_touch_timestamp`), 'Asia/Shanghai') BETWEEN '2018-09-01 00:00:00' AND '2018-09-07 23:59:59'
), 

week_events AS (
    SELECT 
      DISTINCT `user_pseudo_id`,
      CASE 
        WHEN DATETIME(TIMESTAMP_MICROS(`event_timestamp`), 'Asia/Shanghai') BETWEEN '2018-09-08 00:00:00' AND '2018-09-14 23:59:59' THEN 'Week 1'
        WHEN DATETIME(TIMESTAMP_MICROS(`event_timestamp`), 'Asia/Shanghai') BETWEEN '2018-09-15 00:00:00' AND '2018-09-21 23:59:59' THEN 'Week 2'
        WHEN DATETIME(TIMESTAMP_MICROS(`event_timestamp`), 'Asia/Shanghai') BETWEEN '2018-09-22 00:00:00' AND '2018-09-28 23:59:59' THEN 'Week 3'
      END AS week
    FROM `firebase-public-project.analytics_153293282.events_*`
    WHERE
        _TABLE_SUFFIX BETWEEN '20180908' AND '20180928'
        AND `user_pseudo_id` IN (SELECT `user_pseudo_id` FROM new_users)
        AND DATETIME(TIMESTAMP_MICROS(`event_timestamp`), 'Asia/Shanghai') BETWEEN '2018-09-08 00:00:00' AND '2018-09-28 23:59:59'
),

retention AS (
    SELECT
      week,
      COUNT(DISTINCT `user_pseudo_id`) AS retained_users
    FROM week_events
    WHERE week IS NOT NULL
    GROUP BY week
)

SELECT 
  week AS Week,
  ROUND( (retained_users / (SELECT COUNT(*) FROM new_users)) * 100 , 4) AS Retention_Rate
FROM retention
ORDER BY week;