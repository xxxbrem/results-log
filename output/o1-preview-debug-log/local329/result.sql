SELECT COUNT(DISTINCT a."session") AS unique_sessions
FROM (
    SELECT "session", MIN("stamp") AS input_stamp
    FROM "activity_log"
    WHERE "path" = '/input'
    GROUP BY "session"
) a
JOIN (
    SELECT "session", MIN("stamp") AS confirm_stamp
    FROM "activity_log"
    WHERE "path" = '/confirm'
    GROUP BY "session"
) b ON a."session" = b."session"
WHERE a.input_stamp < b.confirm_stamp;