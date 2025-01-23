SELECT
  event_name AS Event_Type,
  ROUND(
    SAFE_DIVIDE(
      COUNT(DISTINCT CASE WHEN DATE_DIFF(DATE(TIMESTAMP_MICROS(event_timestamp)),
                                         DATE(TIMESTAMP_MICROS(user_first_touch_timestamp)),
                                         DAY) BETWEEN 8 AND 14 THEN user_pseudo_id END),
      COUNT(DISTINCT user_pseudo_id)
    ),
    4
  ) AS Second_Week_Retention_Rate
FROM `firebase-public-project.analytics_153293282.events_*`
WHERE event_name LIKE '%_quickplay'
  AND DATE(TIMESTAMP_MICROS(user_first_touch_timestamp)) BETWEEN '2018-08-01' AND '2018-08-15'
GROUP BY Event_Type
ORDER BY Second_Week_Retention_Rate ASC
LIMIT 1