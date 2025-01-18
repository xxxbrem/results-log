SELECT
  P."period",
  P."game_clock",
  ROUND(SUM(CASE WHEN P."team_name" = G."h_name" THEN P."points_scored" ELSE 0 END) OVER (
    ORDER BY P."period", P."elapsed_time_sec"
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ), 4) AS "home_score",
  ROUND(SUM(CASE WHEN P."team_name" = G."a_name" THEN P."points_scored" ELSE 0 END) OVER (
    ORDER BY P."period", P."elapsed_time_sec"
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ), 4) AS "away_score",
  P."team_name" AS "scoring_team",
  P."event_description" AS "description"
FROM NCAA_BASKETBALL.NCAA_BASKETBALL."MBB_PBP_SR" AS P
JOIN NCAA_BASKETBALL.NCAA_BASKETBALL."MBB_GAMES_SR" AS G ON P."game_id" = G."game_id"
WHERE P."game_id" = '95cda731-b593-42cd-8573-621a3d1369dc'
  AND P."event_type" IN ('twopointmade', 'threepointmade', 'freethrowmade')
ORDER BY P."period", P."elapsed_time_sec";