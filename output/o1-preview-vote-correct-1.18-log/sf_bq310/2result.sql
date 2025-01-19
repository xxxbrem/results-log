SELECT "title"
FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS,
     LATERAL FLATTEN(input => SPLIT("tags", '|')) AS f
WHERE "title" ILIKE '%how%'
  AND f.value IN ('android-layout', 'android-activity', 'android-intent')
ORDER BY "view_count" DESC NULLS LAST
LIMIT 1;