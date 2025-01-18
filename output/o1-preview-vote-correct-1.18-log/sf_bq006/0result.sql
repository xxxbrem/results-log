WITH daily_counts AS (
  SELECT
    "date",
    COUNT("unique_key") AS "daily_count"
  FROM AUSTIN.AUSTIN_INCIDENTS.INCIDENTS_2016
  WHERE "descript" = 'PUBLIC INTOXICATION'
    AND "date" BETWEEN '2016-01-01' AND '2016-12-31'
  GROUP BY "date"
),
stats AS (
  SELECT
    AVG("daily_count") AS "mean_count",
    STDDEV_SAMP("daily_count") AS "stddev_count"
  FROM daily_counts
),
z_scores AS (
  SELECT
    dc."date",
    dc."daily_count",
    ROUND((dc."daily_count" - s."mean_count") / NULLIF(s."stddev_count", 0), 4) AS "z_score"
  FROM daily_counts dc, stats s
)
SELECT "date"
FROM z_scores
ORDER BY "z_score" DESC NULLS LAST
LIMIT 1 OFFSET 1;