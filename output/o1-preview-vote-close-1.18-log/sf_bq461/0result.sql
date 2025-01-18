SELECT
    "period" AS "Period",
    "game_clock" AS "Game_clock",
    CONCAT(
        TO_CHAR(wildcats_score, 'FM9999.0000'), ' - ', TO_CHAR(fighting_irish_score, 'FM9999.0000')
    ) AS "Team_scores",
    CASE
        WHEN "team_id" = '2267a1f4-68f6-418b-aaf6-2aa0c4b291f1' THEN 'Wildcats'
        WHEN "team_id" = '80962f09-8821-48b6-8cf0-0cf0eea56aa8' THEN 'Fighting Irish'
        ELSE "team_name"
    END AS "Team_scored",
    "event_description" AS "Event_description"
FROM (
    SELECT
        "period",
        "game_clock",
        "elapsed_time_sec",
        "points_scored",
        "team_id",
        "team_name",
        "event_description",
        SUM(CASE WHEN "team_id" = '2267a1f4-68f6-418b-aaf6-2aa0c4b291f1' THEN "points_scored" ELSE 0 END)
            OVER(
                ORDER BY "elapsed_time_sec"
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS wildcats_score,
        SUM(CASE WHEN "team_id" = '80962f09-8821-48b6-8cf0-0cf0eea56aa8' THEN "points_scored" ELSE 0 END)
            OVER(
                ORDER BY "elapsed_time_sec"
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS fighting_irish_score
    FROM
        NCAA_BASKETBALL.NCAA_BASKETBALL.MBB_PBP_SR
    WHERE
        "game_id" = '95cda731-b593-42cd-8573-621a3d1369dc'
            AND "points_scored" > 0
    )
ORDER BY
    "elapsed_time_sec" ASC;