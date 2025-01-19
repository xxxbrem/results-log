WITH balls_with_runs AS (
    SELECT
        bbb.match_id,
        bbb.innings_no,
        bbb.over_id,
        bbb.bowler,
        COALESCE(bs.runs_scored, 0) AS runs_off_bat,
        CASE WHEN er.extra_type IN ('wides', 'noballs') THEN er.extra_runs ELSE 0 END AS extra_runs_bowler
    FROM ball_by_ball AS bbb
    LEFT JOIN batsman_scored AS bs
        ON bbb.match_id = bs.match_id
        AND bbb.innings_no = bs.innings_no
        AND bbb.over_id = bs.over_id
        AND bbb.ball_id = bs.ball_id
    LEFT JOIN extra_runs AS er
        ON bbb.match_id = er.match_id
        AND bbb.innings_no = er.innings_no
        AND bbb.over_id = er.over_id
        AND bbb.ball_id = er.ball_id
)
, per_over_runs AS (
    SELECT
        match_id,
        over_id AS over_number,
        bowler,
        SUM(runs_off_bat + extra_runs_bowler) AS runs_conceded_in_over
    FROM balls_with_runs
    GROUP BY match_id, innings_no, over_number, bowler
)
SELECT
    p.player_name AS bowler_name,
    por.runs_conceded_in_over,
    por.match_id,
    por.over_number
FROM per_over_runs AS por
JOIN player AS p
    ON por.bowler = p.player_id
ORDER BY
    por.runs_conceded_in_over DESC
LIMIT 3;