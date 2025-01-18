SELECT "path" AS "Web_page", COUNT(DISTINCT "session") AS "UniqueSessions"
FROM (
  SELECT "session", "path"
  FROM (
    SELECT "session", "path",
      ROW_NUMBER() OVER (PARTITION BY "session" ORDER BY "stamp" ASC) AS rn_start,
      ROW_NUMBER() OVER (PARTITION BY "session" ORDER BY "stamp" DESC) AS rn_end
    FROM "LOG"."LOG"."ACTIVITY_LOG"
  ) sub
  WHERE rn_start = 1 OR rn_end = 1
) start_end_pages
GROUP BY "path"
ORDER BY "UniqueSessions" DESC NULLS LAST;