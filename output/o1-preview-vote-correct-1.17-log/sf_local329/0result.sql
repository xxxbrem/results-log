SELECT COUNT(DISTINCT "session") AS "unique_sessions"
FROM (
    SELECT "session",
           MIN(CASE WHEN "path" = '/regist/input' THEN "stamp" END) AS "input_stamp",
           MIN(CASE WHEN "path" = '/regist/confirm' THEN "stamp" END) AS "confirm_stamp"
    FROM LOG.LOG.FORM_LOG
    WHERE "path" IN ('/regist/input', '/regist/confirm')
    GROUP BY "session"
    HAVING "input_stamp" IS NOT NULL AND "confirm_stamp" IS NOT NULL AND "input_stamp" < "confirm_stamp"
) AS sub;