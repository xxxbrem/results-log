SELECT COUNT(DISTINCT "session") AS number_of_unique_sessions
FROM (
    SELECT "session",
           MIN(CASE WHEN "path" = '/regist/input' THEN TRY_TO_TIMESTAMP("stamp", 'YYYY-MM-DD HH24:MI:SS') END) AS input_time,
           MIN(CASE WHEN "path" = '/regist/confirm' THEN TRY_TO_TIMESTAMP("stamp", 'YYYY-MM-DD HH24:MI:SS') END) AS confirm_time
    FROM LOG.LOG.FORM_LOG
    WHERE "path" IN ('/regist/input', '/regist/confirm')
    GROUP BY "session"
) AS sub
WHERE input_time IS NOT NULL AND confirm_time IS NOT NULL AND input_time < confirm_time;