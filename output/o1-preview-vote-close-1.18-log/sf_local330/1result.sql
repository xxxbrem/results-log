WITH session_actions AS (
    SELECT
        "session",
        COALESCE(NULLIF(REGEXP_REPLACE("path", '/+$', ''), ''), '/') AS "web_page",
        ROW_NUMBER() OVER (PARTITION BY "session" ORDER BY "stamp") AS "rn_asc",
        ROW_NUMBER() OVER (PARTITION BY "session" ORDER BY "stamp" DESC) AS "rn_desc"
    FROM LOG.LOG."ACTIVITY_LOG"
)
SELECT
    "web_page",
    COUNT(DISTINCT CASE WHEN "rn_asc" = 1 THEN "session" END) AS "unique_sessions_start_here",
    COUNT(DISTINCT CASE WHEN "rn_desc" = 1 THEN "session" END) AS "unique_sessions_end_here"
FROM session_actions
GROUP BY "web_page"
ORDER BY "web_page" ASC NULLS LAST;