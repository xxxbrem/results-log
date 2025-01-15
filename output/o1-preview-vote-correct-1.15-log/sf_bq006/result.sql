WITH daily_counts AS (
    SELECT "date", COUNT(*) AS "incident_count"
    FROM AUSTIN.AUSTIN_INCIDENTS.INCIDENTS_2016
    WHERE "descript" = 'PUBLIC INTOXICATION'
      AND "date" BETWEEN '2016-01-01' AND '2016-12-31'
    GROUP BY "date"
),
stats AS (
    SELECT AVG("incident_count") AS mean_count, STDDEV_SAMP("incident_count") AS std_dev
    FROM daily_counts
),
z_scores AS (
    SELECT d."date",
           ROUND((d."incident_count" - s.mean_count) / NULLIF(s.std_dev, 0), 4) AS z_score
    FROM daily_counts d
    CROSS JOIN stats s
)
SELECT "date"
FROM z_scores
ORDER BY z_score DESC NULLS LAST
LIMIT 1 OFFSET 1;