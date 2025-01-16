SELECT "title"
FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS
WHERE "title" ILIKE '%how%'
  AND (
    '|' || "tags" || '|' LIKE '%|android|%'
    OR '|' || "tags" || '|' LIKE '%|android-layout|%'
    OR '|' || "tags" || '|' LIKE '%|android-activity|%'
    OR '|' || "tags" || '|' LIKE '%|android-intent|%'
    OR '|' || "tags" || '|' LIKE '%|android-view|%'
    OR '|' || "tags" || '|' LIKE '%|android-fragment|%'
    OR '|' || "tags" || '|' LIKE '%|android-adapter|%'
  )
ORDER BY "view_count" DESC NULLS LAST
LIMIT 1;