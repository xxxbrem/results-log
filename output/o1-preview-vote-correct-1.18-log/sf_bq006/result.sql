WITH daily_counts AS (
  SELECT "date", COUNT(*) AS "daily_count"
  FROM "AUSTIN"."AUSTIN_INCIDENTS"."INCIDENTS_2016"
  WHERE "descript" = 'PUBLIC INTOXICATION'
  GROUP BY "date"
),
statistics AS (
  SELECT AVG("daily_count") AS "mean_count", STDDEV("daily_count") AS "stddev_count"
  FROM daily_counts
),
z_scores AS (
  SELECT
    d."date",
    d."daily_count",
    ROUND((d."daily_count" - s."mean_count") / s."stddev_count", 4) AS "z_score"
  FROM daily_counts d
  CROSS JOIN statistics s
),
ranked_z_scores AS (
  SELECT
    "date",
    "z_score",
    ROW_NUMBER() OVER (ORDER BY "z_score" DESC NULLS LAST, "date" ASC) AS "rank"
  FROM z_scores
)
SELECT "date"
FROM ranked_z_scores
WHERE "rank" = 2;