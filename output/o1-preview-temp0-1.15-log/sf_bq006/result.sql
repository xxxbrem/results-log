WITH daily_counts AS (
  SELECT "date", COUNT(*) AS "incident_count"
  FROM AUSTIN.AUSTIN_INCIDENTS.INCIDENTS_2016
  WHERE "descript" = 'PUBLIC INTOXICATION' AND "date" BETWEEN '2016-01-01' AND '2016-12-31'
  GROUP BY "date"
),
stats AS (
  SELECT AVG("incident_count") AS mean_count, STDDEV_SAMP("incident_count") AS stddev_count
  FROM daily_counts
),
daily_zscores AS (
  SELECT 
    dc."date", 
    dc."incident_count", 
    ROUND((dc."incident_count" - s.mean_count)/s.stddev_count, 4) AS z_score
  FROM daily_counts dc
  CROSS JOIN stats s
)
SELECT "date"
FROM daily_zscores
ORDER BY z_score DESC NULLS LAST
LIMIT 1 OFFSET 1;