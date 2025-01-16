SELECT MAX("answer_count") AS "highest_answer_count"
FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS
WHERE "tags" LIKE '%python-2.x%' AND "tags" NOT LIKE '%python-3.x%';