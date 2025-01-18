WITH
  teams_per_league AS (
    SELECT DISTINCT "league_id", "team_api_id"
    FROM (
      SELECT "league_id", "home_team_api_id" AS "team_api_id"
      FROM "EU_SOCCER"."EU_SOCCER"."MATCH"
      UNION
      SELECT "league_id", "away_team_api_id" AS "team_api_id"
      FROM "EU_SOCCER"."EU_SOCCER"."MATCH"
    )
  ),
  wins_data AS (
    SELECT
      "league_id",
      CASE
        WHEN "home_team_goal" > "away_team_goal" THEN "home_team_api_id"
        WHEN "away_team_goal" > "home_team_goal" THEN "away_team_api_id"
        ELSE NULL
      END AS "winning_team_api_id"
    FROM
      "EU_SOCCER"."EU_SOCCER"."MATCH"
  ),
  team_wins AS (
    SELECT
      "league_id",
      "winning_team_api_id" AS "team_api_id",
      COUNT(*) AS "wins"
    FROM
      wins_data
    WHERE
      "winning_team_api_id" IS NOT NULL
    GROUP BY
      "league_id",
      "winning_team_api_id"
  ),
  teams_with_wins AS (
    SELECT
      tpl."league_id",
      tpl."team_api_id",
      COALESCE(tw."wins", 0) AS "wins"
    FROM
      teams_per_league tpl
    LEFT JOIN
      team_wins tw
    ON
      tpl."league_id" = tw."league_id" AND tpl."team_api_id" = tw."team_api_id"
  ),
  min_wins_per_league AS (
    SELECT
      "league_id",
      MIN("wins") AS "min_wins"
    FROM
      teams_with_wins
    GROUP BY
      "league_id"
  ),
  teams_with_min_wins AS (
    SELECT
      tww."league_id",
      tww."team_api_id",
      tww."wins"
    FROM
      teams_with_wins tww
    JOIN
      min_wins_per_league mwpl
    ON
      tww."league_id" = mwpl."league_id" AND tww."wins" = mwpl."min_wins"
  )
SELECT
  "League_name",
  "Team_name",
  "Wins"
FROM (
  SELECT
    l."name" AS "League_name",
    t."team_long_name" AS "Team_name",
    twm."wins" AS "Wins",
    ROW_NUMBER() OVER (PARTITION BY l."name" ORDER BY t."team_long_name") AS "rn"
  FROM
    teams_with_min_wins twm
  JOIN
    "EU_SOCCER"."EU_SOCCER"."TEAM" t
  ON
    twm."team_api_id" = t."team_api_id"
  JOIN
    "EU_SOCCER"."EU_SOCCER"."LEAGUE" l
  ON
    twm."league_id" = l."id"
) sub
WHERE
  sub."rn" = 1
ORDER BY
  "League_name";