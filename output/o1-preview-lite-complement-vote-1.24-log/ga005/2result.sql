WITH
  user_first_events AS (
    SELECT
      `user_pseudo_id`,
      MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_event_date,
      DATE_TRUNC(MIN(PARSE_DATE('%Y%m%d', event_date)), WEEK(MONDAY)) AS cohort_week_start
    FROM
      `firebase-public-project.analytics_153293282.events_*`
    WHERE
      PARSE_DATE('%Y%m%d', event_date) BETWEEN DATE('2018-07-09') AND DATE('2018-10-02')
    GROUP BY
      `user_pseudo_id`
  ),

  user_events AS (
    SELECT
      e.`user_pseudo_id`,
      PARSE_DATE('%Y%m%d', e.event_date) AS event_date,
      ufe.cohort_week_start,
      DATE_TRUNC(PARSE_DATE('%Y%m%d', e.event_date), WEEK(MONDAY)) AS event_week_start
    FROM
      `firebase-public-project.analytics_153293282.events_*` e
    JOIN
      user_first_events ufe
    ON
      e.`user_pseudo_id` = ufe.`user_pseudo_id`
    WHERE
      PARSE_DATE('%Y%m%d', e.event_date) BETWEEN DATE('2018-07-09') AND DATE('2018-10-02')
  ),

  user_week_diffs AS (
    SELECT
      `user_pseudo_id`,
      cohort_week_start,
      DATE_DIFF(event_week_start, cohort_week_start, WEEK(MONDAY)) AS week_diff
    FROM
      user_events
  ),

  cohort_retention AS (
    SELECT
      cohort_week_start,
      week_diff,
      COUNT(DISTINCT `user_pseudo_id`) AS users
    FROM
      user_week_diffs
    WHERE
      week_diff BETWEEN 0 AND 2
    GROUP BY
      cohort_week_start,
      week_diff
  ),

  cohort_sizes AS (
    SELECT
      cohort_week_start,
      users AS Users_in_Cohort
    FROM
      cohort_retention
    WHERE
      week_diff = 0
  ),

  retention_pivot AS (
    SELECT
      cs.cohort_week_start,
      cs.Users_in_Cohort,
      IFNULL(cr1.users, 0) AS returned_week1,
      IFNULL(cr2.users, 0) AS returned_week2
    FROM
      cohort_sizes cs
    LEFT JOIN
      (SELECT cohort_week_start, users FROM cohort_retention WHERE week_diff = 1) cr1
    ON
      cs.cohort_week_start = cr1.cohort_week_start
    LEFT JOIN
      (SELECT cohort_week_start, users FROM cohort_retention WHERE week_diff = 2) cr2
    ON
      cs.cohort_week_start = cr2.cohort_week_start
    WHERE
      cs.cohort_week_start <= DATE_SUB(DATE('2018-10-02'), INTERVAL 2 WEEK)
    ORDER BY
      cs.cohort_week_start
  )

SELECT
  cohort_week_start AS Cohort_Week_Start,
  Users_in_Cohort,
  ROUND(100 * returned_week1 / Users_in_Cohort, 4) AS Retention_Week1_pct,
  ROUND(100 * returned_week2 / Users_in_Cohort, 4) AS Retention_Week2_pct
FROM
  retention_pivot