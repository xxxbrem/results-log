WITH QUESTIONS_CTE AS (
   SELECT Q."id",
          Q."creation_date",
          TO_TIMESTAMP_LTZ(CAST(Q."creation_date" / 1e6 AS BIGINT)) AS "question_creation_timestamp",
          TO_VARCHAR(TO_TIMESTAMP_LTZ(CAST(Q."creation_date" / 1e6 AS BIGINT)), 'Dy') AS "Day_of_Week"
   FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_QUESTIONS Q
   WHERE Q."creation_date" >= 1609459200000000 AND Q."creation_date" < 1640995200000000 
),
ANSWERS_CTE AS (
   SELECT A."parent_id" AS "question_id",
          MIN(A."creation_date") AS "earliest_answer_creation_date",
          MIN(TO_TIMESTAMP_LTZ(CAST(A."creation_date" / 1e6 AS BIGINT))) AS "earliest_answer_timestamp"
   FROM STACKOVERFLOW.STACKOVERFLOW.POSTS_ANSWERS A
   GROUP BY A."parent_id"
)
SELECT Q."Day_of_Week",
       COUNT(*) AS "Number_of_Questions",
       SUM(CASE
             WHEN A."earliest_answer_timestamp" IS NOT NULL
              AND DATEDIFF('second', Q."question_creation_timestamp", A."earliest_answer_timestamp") BETWEEN 0 AND 3600
             THEN 1
             ELSE 0
           END) AS "Number_Answered_within_1hr",
       ROUND(
         (SUM(CASE
                WHEN A."earliest_answer_timestamp" IS NOT NULL
                 AND DATEDIFF('second', Q."question_creation_timestamp", A."earliest_answer_timestamp") BETWEEN 0 AND 3600
                THEN 1
                ELSE 0
              END) * 100.0) / COUNT(*),
         4) AS "Percentage_Answered_within_1hr"
FROM QUESTIONS_CTE Q
LEFT JOIN ANSWERS_CTE A ON A."question_id" = Q."id"
GROUP BY Q."Day_of_Week"
ORDER BY CASE Q."Day_of_Week"
            WHEN 'Mon' THEN 1
            WHEN 'Tue' THEN 2
            WHEN 'Wed' THEN 3
            WHEN 'Thu' THEN 4
            WHEN 'Fri' THEN 5
            WHEN 'Sat' THEN 6
            WHEN 'Sun' THEN 7
            ELSE 8
         END;