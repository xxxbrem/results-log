SELECT COUNT(DISTINCT "session") AS unique_sessions
FROM (
    SELECT "session",
        MIN(CASE WHEN "path" = '/regist/input' THEN TO_TIMESTAMP("stamp") END) AS input_stamp,
        MIN(CASE WHEN "path" = '/regist/confirm' THEN TO_TIMESTAMP("stamp") END) AS confirm_stamp
    FROM LOG.LOG.FORM_LOG
    GROUP BY "session"
) AS sub
WHERE input_stamp IS NOT NULL AND confirm_stamp IS NOT NULL AND input_stamp < confirm_stamp;