WITH daily_counts AS (
   SELECT "date", COUNT(*) AS "incident_count"
   FROM AUSTIN.AUSTIN_INCIDENTS.INCIDENTS_2016
   WHERE "descript" LIKE '%PUBLIC INTOXICATION%'
     AND "date" BETWEEN '2016-01-01' AND '2016-12-31'
   GROUP BY "date"
),
stats AS (
   SELECT AVG("incident_count") AS mean_count, STDDEV("incident_count") AS stddev_count FROM daily_counts
),
z_scores AS (
    SELECT 
        daily_counts."date", 
        daily_counts."incident_count", 
        ROUND((daily_counts."incident_count" - stats.mean_count) / stats.stddev_count, 4) AS z_score
    FROM daily_counts, stats
)
SELECT "date"
FROM z_scores
ORDER BY z_score DESC NULLS LAST
LIMIT 1 OFFSET 1;