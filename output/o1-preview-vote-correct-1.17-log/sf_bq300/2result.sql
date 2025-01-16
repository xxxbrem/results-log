SELECT MAX("answer_count") AS "highest_answer_count"
FROM "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS"
WHERE (("tags" LIKE '%python-2%' OR "title" ILIKE '%python%2%' OR "body" ILIKE '%python%2%'))
  AND ("tags" NOT LIKE '%python-3%' AND "title" NOT ILIKE '%python%3%' AND "body" NOT ILIKE '%python%3%');