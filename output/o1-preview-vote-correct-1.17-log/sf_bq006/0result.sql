WITH daily_counts AS (
  SELECT "date", COUNT(*) AS "daily_count"
  FROM AUSTIN.AUSTIN_INCIDENTS.INCIDENTS_2016
  WHERE "descript" = 'PUBLIC INTOXICATION'
    AND "date" >= '2016-01-01' AND "date" < '2017-01-01'
  GROUP BY "date"
),
statistics AS (
  SELECT 
    AVG("daily_count") AS "mean_count",
    STDDEV("daily_count") AS "stddev_count"
  FROM daily_counts
),
z_scores AS (
  SELECT 
    dc."date", 
    dc."daily_count",
    ROUND((dc."daily_count" - s."mean_count") / NULLIF(s."stddev_count", 0), 4) AS "z_score"
  FROM daily_counts dc CROSS JOIN statistics s
),
ranked_z_scores AS (
  SELECT 
    "date",
    "z_score",
    ROW_NUMBER() OVER (ORDER BY "z_score" DESC NULLS LAST) AS rn
  FROM z_scores
)
SELECT "date"
FROM ranked_z_scores
WHERE rn = 2;