SELECT TO_CHAR("date", 'YYYY-MM-DD') AS "Date"
FROM (
    SELECT
        dc."date",
        dc."daily_count",
        ROUND((dc."daily_count" - stats."avg_count") / NULLIF(stats."stddev_count", 0), 4) AS "z_score"
    FROM (
        SELECT
            "date",
            COUNT(*) AS "daily_count"
        FROM AUSTIN.AUSTIN_INCIDENTS.INCIDENTS_2016
        WHERE "descript" = 'PUBLIC INTOXICATION'
          AND "date" BETWEEN '2016-01-01' AND '2016-12-31'
        GROUP BY "date"
    ) dc
    CROSS JOIN (
        SELECT
            AVG("daily_count") AS "avg_count",
            STDDEV_SAMP("daily_count") AS "stddev_count"
        FROM (
            SELECT
                "date",
                COUNT(*) AS "daily_count"
            FROM AUSTIN.AUSTIN_INCIDENTS.INCIDENTS_2016
            WHERE "descript" = 'PUBLIC INTOXICATION'
              AND "date" BETWEEN '2016-01-01' AND '2016-12-31'
            GROUP BY "date"
        ) sub
    ) stats
) z_scores
ORDER BY "z_score" DESC NULLS LAST
LIMIT 1 OFFSET 1;