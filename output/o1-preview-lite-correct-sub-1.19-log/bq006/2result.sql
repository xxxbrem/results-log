WITH daily_counts AS (
    SELECT
        date,
        COUNT(*) AS incident_count
    FROM `bigquery-public-data.austin_incidents.incidents_2016`
    WHERE LOWER(descript) = 'public intoxication'
    GROUP BY date
),
stats AS (
    SELECT
        AVG(incident_count) AS mean_count,
        STDDEV(incident_count) AS stddev_count
    FROM daily_counts
),
z_scores AS (
    SELECT
        dc.date,
        dc.incident_count,
        ROUND((dc.incident_count - s.mean_count) / s.stddev_count, 4) AS z_score
    FROM daily_counts dc
    CROSS JOIN stats s
)
SELECT date
FROM z_scores
ORDER BY z_score DESC
LIMIT 1 OFFSET 1;