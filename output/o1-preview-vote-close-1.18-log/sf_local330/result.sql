WITH session_pages AS (
  SELECT
    "session",
    "path",
    ROW_NUMBER() OVER (PARTITION BY "session" ORDER BY TRY_TO_TIMESTAMP("stamp") ASC NULLS LAST) AS rn_first,
    ROW_NUMBER() OVER (PARTITION BY "session" ORDER BY TRY_TO_TIMESTAMP("stamp") DESC NULLS LAST) AS rn_last
  FROM
    "LOG"."LOG"."ACTIVITY_LOG"
  WHERE
    TRY_TO_TIMESTAMP("stamp") IS NOT NULL
)
SELECT
  "path" AS web_page,
  COUNT(DISTINCT "session") AS count_sessions
FROM
  session_pages
WHERE
  rn_first = 1 OR rn_last = 1
GROUP BY
  "path";