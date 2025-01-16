SELECT "id", "title", "answer_count"
FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS
WHERE ("tags" LIKE '%python-2.x%' OR "title" ILIKE '%python%2%')
  AND "tags" NOT LIKE '%python-3.x%'
  AND "title" NOT ILIKE '%python%3%'
ORDER BY "answer_count" DESC NULLS LAST
LIMIT 1;