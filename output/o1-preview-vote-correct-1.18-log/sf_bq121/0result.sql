WITH badge_counts AS (
  SELECT
    B."user_id",
    COUNT(*) AS "badge_count"
  FROM
    STACKOVERFLOW.STACKOVERFLOW.BADGES B
  GROUP BY
    B."user_id"
)
SELECT
  DATEDIFF('year', TO_TIMESTAMP( U."creation_date" / 1e6 ), TO_DATE('2021-10-01')) AS "years_of_membership",
  ROUND(AVG(U."reputation"), 4) AS "average_reputation",
  ROUND(AVG(COALESCE(badge_counts."badge_count", 0)), 4) AS "average_badges"
FROM
  STACKOVERFLOW.STACKOVERFLOW.USERS U
  LEFT JOIN badge_counts ON U."id" = badge_counts."user_id"
WHERE
  U."creation_date" <= 1633046400000000  -- October 1, 2021 in microseconds
GROUP BY
  "years_of_membership"
ORDER BY
  "years_of_membership";