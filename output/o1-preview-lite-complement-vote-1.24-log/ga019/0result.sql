SELECT
    100.0 * COUNTIF(days_diff >= 7) / COUNT(*) AS percentage_of_users_did_not_uninstall_within_7_days
FROM (
    SELECT
        installs.user_pseudo_id,
        installs.user_first_touch_timestamp,
        last_events.last_event_timestamp,
        (last_events.last_event_timestamp - installs.user_first_touch_timestamp) / (1000000 * 60 * 60 * 24) AS days_diff
    FROM (
        SELECT
            user_pseudo_id,
            user_first_touch_timestamp
        FROM
            `firebase-public-project.analytics_153293282.events_*`
        WHERE
            _TABLE_SUFFIX BETWEEN '20180801' AND '20180930'
        GROUP BY
            user_pseudo_id, user_first_touch_timestamp
        HAVING
            DATE(TIMESTAMP_MICROS(user_first_touch_timestamp)) BETWEEN '2018-08-01' AND '2018-09-30'
    ) AS installs
    LEFT JOIN (
        SELECT
            user_pseudo_id,
            MAX(event_timestamp) AS last_event_timestamp
        FROM
            `firebase-public-project.analytics_153293282.events_*`
        WHERE
            _TABLE_SUFFIX BETWEEN '20180801' AND '20181003'
        GROUP BY
            user_pseudo_id
    ) AS last_events
    ON
        installs.user_pseudo_id = last_events.user_pseudo_id
)