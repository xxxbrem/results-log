SELECT MAX("answer_count") AS "Highest_number_of_answers"
FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS
WHERE "tags" LIKE '%python-2%' AND "tags" NOT LIKE '%python-3%';