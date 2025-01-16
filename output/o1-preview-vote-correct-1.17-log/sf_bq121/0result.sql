WITH UserMembership AS (
  SELECT
    "id" AS "user_id",
    CASE
      WHEN "creation_date" >= 1e15 THEN TO_TIMESTAMP_NTZ("creation_date" / 1000000)
      WHEN "creation_date" >= 1e12 THEN TO_TIMESTAMP_NTZ("creation_date" / 1000)
      ELSE TO_TIMESTAMP_NTZ("creation_date")
    END AS "creation_timestamp",
    "reputation"
  FROM STACKOVERFLOW.STACKOVERFLOW.USERS
  WHERE (
    CASE
      WHEN "creation_date" >= 1e15 THEN TO_TIMESTAMP_NTZ("creation_date" / 1000000)
      WHEN "creation_date" >= 1e12 THEN TO_TIMESTAMP_NTZ("creation_date" / 1000)
      ELSE TO_TIMESTAMP_NTZ("creation_date")
    END
  ) <= '2021-10-01'
),
UserBadges AS (
  SELECT
    "user_id",
    COUNT(*) AS "Badge_Count"
  FROM STACKOVERFLOW.STACKOVERFLOW.BADGES
  GROUP BY "user_id"
)
SELECT
  DATEDIFF('year', UM."creation_timestamp", '2021-10-01') AS "Years_of_Membership",
  ROUND(AVG(UM."reputation"), 4) AS "Average_Reputation",
  ROUND(AVG(COALESCE(UB."Badge_Count", 0)), 4) AS "Average_Number_of_Badges"
FROM UserMembership UM
LEFT JOIN UserBadges UB ON UM."user_id" = UB."user_id"
GROUP BY "Years_of_Membership"
ORDER BY "Years_of_Membership";