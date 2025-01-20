SELECT "title"
FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS
WHERE "title" ILIKE '%how%'
  AND (
    REGEXP_LIKE("tags", '(^|[|])android-layout([|]|$)') OR
    REGEXP_LIKE("tags", '(^|[|])android-activity([|]|$)') OR
    REGEXP_LIKE("tags", '(^|[|])android-intent([|]|$)')
  )
ORDER BY "view_count" DESC NULLS LAST
LIMIT 1;