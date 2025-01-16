WITH daily_counts AS (
    SELECT
        "date",
        COUNT(*) AS daily_count
    FROM AUSTIN.AUSTIN_INCIDENTS.INCIDENTS_2016
    WHERE "descript" = 'PUBLIC INTOXICATION'
    GROUP BY "date"
),
stats AS (
    SELECT
        AVG(daily_count) AS "mean_count",
        STDDEV_POP(daily_count) AS "stddev_count"
    FROM daily_counts
),
z_scores AS (
    SELECT
        dc."date",
        dc.daily_count,
        (dc.daily_count - s."mean_count") / s."stddev_count" AS "z_score"
    FROM daily_counts dc
    CROSS JOIN stats s
),
ranked_dates AS (
    SELECT
        "date",
        "z_score",
        RANK() OVER (ORDER BY "z_score" DESC NULLS LAST) AS "z_rank"
    FROM z_scores
)
SELECT "date"
FROM ranked_dates
WHERE "z_rank" = 2;