WITH installations AS (
  SELECT 
    user_pseudo_id, 
    MIN(event_timestamp) AS first_open_timestamp
  FROM 
    `firebase-public-project.analytics_153293282.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20180801' AND '20180930'
    AND event_name = 'first_open'
  GROUP BY 
    user_pseudo_id
),

uninstalls AS (
  SELECT 
    user_pseudo_id, 
    MIN(event_timestamp) AS uninstall_timestamp
  FROM
    `firebase-public-project.analytics_153293282.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20180801' AND '20180930'
    AND event_name = 'app_remove'
  GROUP BY 
    user_pseudo_id
),

user_activity AS (
  SELECT
    inst.user_pseudo_id,
    inst.first_open_timestamp,
    uninst.uninstall_timestamp,
    CASE 
      WHEN uninst.uninstall_timestamp IS NULL THEN FALSE
      WHEN uninst.uninstall_timestamp - inst.first_open_timestamp <= 7 * 24 * 60 * 60 * 1000000 THEN TRUE
      ELSE FALSE
    END AS uninstalled_within_7_days
  FROM
    installations inst
  LEFT JOIN
    uninstalls uninst
  ON
    inst.user_pseudo_id = uninst.user_pseudo_id
)

SELECT
  ROUND(
    (COUNTIF(NOT uninstalled_within_7_days) / COUNT(*)) * 100, 4
  ) AS percentage_of_users_did_not_uninstall_within_7_days
FROM
  user_activity