WITH questions AS (
  SELECT
    id,
    FORMAT_TIMESTAMP('%A', creation_date) AS Day_of_Week,
    creation_date
  FROM
    `bigquery-public-data.stackoverflow.posts_questions`
  WHERE
    creation_date BETWEEN '2021-01-01' AND '2021-12-31'
),
first_answers AS (
  SELECT
    q.id AS question_id,
    q.Day_of_Week,
    q.creation_date AS question_date,
    MIN(a.creation_date) AS first_answer_date
  FROM
    questions q
  LEFT JOIN
    `bigquery-public-data.stackoverflow.posts_answers` a
  ON
    q.id = a.parent_id
  GROUP BY
    q.id, q.Day_of_Week, q.creation_date
),
answers_within_one_hour AS (
  SELECT
    *,
    TIMESTAMP_DIFF(first_answer_date, question_date, MINUTE) AS minutes_to_first_answer
  FROM
    first_answers
)

SELECT
  Day_of_Week,
  COUNT(*) AS Total_Questions,
  COUNTIF(minutes_to_first_answer <= 60 AND minutes_to_first_answer >= 0) AS Answered_within_1_hour,
  ROUND(COUNTIF(minutes_to_first_answer <= 60 AND minutes_to_first_answer >= 0) * 100.0 / COUNT(*), 4) AS Percentage
FROM
  answers_within_one_hour
GROUP BY
  Day_of_Week
ORDER BY
  CASE Day_of_Week
    WHEN 'Monday' THEN 1
    WHEN 'Tuesday' THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4
    WHEN 'Friday' THEN 5
    WHEN 'Saturday' THEN 6
    WHEN 'Sunday' THEN 7
  END;