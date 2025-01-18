WITH scoring_events AS (
  SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY "period", "elapsed_time_sec", "event_id") AS "event_number"
  FROM (
    SELECT
      "event_id",
      "period",
      "game_clock",
      "team_market" AS "scoring_team",
      "event_description" AS "description",
      "points_scored",
      CASE WHEN "team_market" = 'Kentucky' THEN "points_scored" ELSE 0 END AS "points_scored_wildcats",
      CASE WHEN "team_market" = 'Notre Dame' THEN "points_scored" ELSE 0 END AS "points_scored_fighting_irish",
      "elapsed_time_sec"
    FROM NCAA_BASKETBALL.NCAA_BASKETBALL.MBB_PBP_SR
    WHERE "game_id" = '95cda731-b593-42cd-8573-621a3d1369dc'
      AND "points_scored" IS NOT NULL
  ) sub
)

SELECT
  "period",
  "game_clock",
  CAST(SUM("points_scored_wildcats") OVER (
    ORDER BY "event_number" ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS FLOAT) AS "team_score_wildcats",
  CAST(SUM("points_scored_fighting_irish") OVER (
    ORDER BY "event_number" ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS FLOAT) AS "team_score_fighting_irish",
  "scoring_team",
  "description"
FROM scoring_events
ORDER BY "event_number";