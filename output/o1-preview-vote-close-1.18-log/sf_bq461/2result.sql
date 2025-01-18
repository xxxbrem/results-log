WITH scoring_events AS (
    SELECT
        "period",
        "game_clock",
        "elapsed_time_sec",
        "team_name",
        "team_id",
        "points_scored",
        "event_description"
    FROM NCAA_BASKETBALL.NCAA_BASKETBALL.MBB_PBP_SR
    WHERE "game_id" = '95cda731-b593-42cd-8573-621a3d1369dc'
      AND "points_scored" > 0
),
team_scores AS (
    SELECT
        se.*,
        SUM(CASE WHEN se."team_id" = '2267a1f4-68f6-418b-aaf6-2aa0c4b291f1' THEN se."points_scored" ELSE 0 END)
            OVER (ORDER BY se."period", se."elapsed_time_sec") AS "Home_Team_Score",
        SUM(CASE WHEN se."team_id" = '80962f09-8821-48b6-8cf0-0cf0eea56aa8' THEN se."points_scored" ELSE 0 END)
            OVER (ORDER BY se."period", se."elapsed_time_sec") AS "Away_Team_Score",
        CASE WHEN se."team_id" = '2267a1f4-68f6-418b-aaf6-2aa0c4b291f1' THEN 'Wildcats'
             WHEN se."team_id" = '80962f09-8821-48b6-8cf0-0cf0eea56aa8' THEN 'Fighting Irish'
             ELSE se."team_name" END AS "Scoring_Team"
    FROM scoring_events se
)
SELECT
    "period" AS "Period",
    "game_clock" AS "Game_Clock",
    ROUND("Home_Team_Score", 4) AS "Home_Team_Score",
    ROUND("Away_Team_Score", 4) AS "Away_Team_Score",
    "Scoring_Team",
    "event_description" AS "Event_Description"
FROM team_scores
ORDER BY "period", "elapsed_time_sec";