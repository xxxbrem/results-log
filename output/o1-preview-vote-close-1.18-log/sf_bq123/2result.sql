WITH question_times AS (
  SELECT
    q."id" AS question_id,
    q."creation_date" AS question_creation_date,
    TO_TIMESTAMP(q."creation_date" / 1000000) AS question_timestamp,
    DAYNAME(TO_TIMESTAMP(q."creation_date" / 1000000)) AS question_day_name
  FROM
    "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS" q
),
answer_times AS (
  SELECT
    a."parent_id" AS question_id,
    MIN(a."creation_date") AS first_answer_creation_date
  FROM
    "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_ANSWERS" a
  GROUP BY
    a."parent_id"
),
question_answer_times AS (
  SELECT
    qt.question_id,
    qt.question_day_name,
    (at.first_answer_creation_date - qt.question_creation_date) AS time_difference_microseconds
  FROM
    question_times qt
  LEFT JOIN
    answer_times at ON qt.question_id = at.question_id
),
question_answer_within_hour AS (
  SELECT
    question_day_name,
    CASE
      WHEN time_difference_microseconds IS NOT NULL AND time_difference_microseconds <= 3600 * 1000000 THEN 1
      ELSE 0
    END AS answered_within_hour
  FROM
    question_answer_times
),
percentages AS (
  SELECT
    question_day_name AS Day,
    ROUND(AVG(answered_within_hour::FLOAT) * 100, 2) AS Percentage
  FROM
    question_answer_within_hour
  GROUP BY
    question_day_name
)
SELECT
  Day,
  Percentage
FROM
  (
    SELECT
      Day,
      Percentage,
      ROW_NUMBER() OVER (ORDER BY Percentage DESC NULLS LAST) AS rn
    FROM
      percentages
  ) ordered_percentages
WHERE
  rn = 3;