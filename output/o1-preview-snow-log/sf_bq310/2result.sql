SELECT "title"
FROM "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS"
WHERE "title" ILIKE '%how%'
  AND "tags" LIKE '%android%'
ORDER BY "view_count" DESC NULLS LAST
LIMIT 1;