WITH initial_cohort AS (
  SELECT DISTINCT user_pseudo_id
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20180702' AND '20180708'
    AND user_first_touch_timestamp BETWEEN UNIX_MICROS(TIMESTAMP '2018-07-02') AND UNIX_MICROS(TIMESTAMP '2018-07-09')
),
user_activity AS (
  SELECT
    user_pseudo_id,
    CASE
      WHEN _TABLE_SUFFIX BETWEEN '20180702' AND '20180708' THEN 'Week0'
      WHEN _TABLE_SUFFIX BETWEEN '20180709' AND '20180715' THEN 'Week1'
      WHEN _TABLE_SUFFIX BETWEEN '20180716' AND '20180722' THEN 'Week2'
      WHEN _TABLE_SUFFIX BETWEEN '20180723' AND '20180729' THEN 'Week3'
      WHEN _TABLE_SUFFIX BETWEEN '20180730' AND '20180805' THEN 'Week4'
    END AS Week
  FROM `firebase-public-project.analytics_153293282.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20180702' AND '20180805'
    AND user_pseudo_id IN (SELECT user_pseudo_id FROM initial_cohort)
),
retention_counts AS (
  SELECT Week, COUNT(DISTINCT user_pseudo_id) AS Number_of_Retained_Users
  FROM user_activity
  GROUP BY Week
),
weeks AS (
  SELECT 'Week0' AS Week UNION ALL
  SELECT 'Week1' UNION ALL
  SELECT 'Week2' UNION ALL
  SELECT 'Week3' UNION ALL
  SELECT 'Week4'
)
SELECT
  weeks.Week,
  (SELECT COUNT(*) FROM initial_cohort) AS Total_New_Users,
  IFNULL(retention_counts.Number_of_Retained_Users, 0) AS Number_of_Retained_Users
FROM weeks
LEFT JOIN retention_counts USING (Week)
ORDER BY Week;