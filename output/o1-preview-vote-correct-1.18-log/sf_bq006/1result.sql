WITH daily_counts AS (
    SELECT "date", COUNT(*) AS "daily_count"
    FROM "AUSTIN"."AUSTIN_INCIDENTS"."INCIDENTS_2016"
    WHERE "descript" = 'PUBLIC INTOXICATION'
    GROUP BY "date"
),
stats AS (
    SELECT AVG("daily_count") AS "mean_count", STDDEV("daily_count") AS "stddev_count"
    FROM daily_counts
),
daily_z_scores AS (
    SELECT 
        dc."date", 
        dc."daily_count",
        ROUND((dc."daily_count" - s."mean_count") / NULLIF(s."stddev_count", 0), 4) AS "z_score"
    FROM daily_counts dc CROSS JOIN stats s
)
SELECT "date"
FROM daily_z_scores
ORDER BY "z_score" DESC NULLS LAST, "date" ASC
LIMIT 1 OFFSET 1;