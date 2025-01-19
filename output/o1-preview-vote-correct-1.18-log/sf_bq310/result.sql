SELECT "title"
FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS
WHERE "title" ILIKE '%how%'
  AND (
    "tags" ILIKE '%android-layout%' OR
    "tags" ILIKE '%android-activity%' OR
    "tags" ILIKE '%android-intent%' OR
    "tags" ILIKE '%android%'
  )
ORDER BY "view_count" DESC NULLS LAST
LIMIT 1;