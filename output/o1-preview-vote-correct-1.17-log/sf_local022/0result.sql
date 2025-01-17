SELECT DISTINCT
    P."player_name" AS Striker_name
FROM
    (
    SELECT 
        BB."striker",
        BB."match_id",
        BB."team_batting",
        SUM(BS."runs_scored") AS total_runs
    FROM 
        IPL.IPL.BALL_BY_BALL AS BB
        JOIN IPL.IPL.BATSMAN_SCORED AS BS
        ON BB."match_id" = BS."match_id"
        AND BB."over_id" = BS."over_id"
        AND BB."ball_id" = BS."ball_id"
        AND BB."innings_no" = BS."innings_no"
    GROUP BY 
        BB."striker",
        BB."match_id",
        BB."team_batting"
    HAVING SUM(BS."runs_scored") >= 100
    ) AS T
    JOIN IPL.IPL.MATCH AS M
    ON T."match_id" = M."match_id"
    JOIN IPL.IPL.PLAYER AS P
    ON T."striker" = P."player_id"
WHERE 
    T."team_batting" <> M."match_winner";