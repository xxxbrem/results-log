WITH daily_counts AS (
    SELECT
        "date",
        COUNT(*) AS count
    FROM
        AUSTIN.AUSTIN_INCIDENTS.INCIDENTS_2016
    WHERE
        "descript" = 'PUBLIC INTOXICATION'
    GROUP BY
        "date"
),
stats AS (
    SELECT
        AVG(count) AS mean_count,
        STDDEV(count) AS stddev_count
    FROM
        daily_counts
),
z_scores AS (
    SELECT
        dc."date",
        dc.count,
        ROUND((dc.count - stats.mean_count) / NULLIF(stats.stddev_count, 0), 4) AS z_score
    FROM
        daily_counts dc
        CROSS JOIN stats
)
SELECT
    "date"
FROM
    z_scores
ORDER BY
    z_score DESC NULLS LAST
LIMIT 1 OFFSET 1;