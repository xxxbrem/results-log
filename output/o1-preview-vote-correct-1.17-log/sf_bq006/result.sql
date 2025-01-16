SELECT "date"
FROM (
    SELECT
        "date",
        incident_count,
        ROUND(
            (incident_count - AVG(incident_count) OVER ())
            / NULLIF(STDDEV_SAMP(incident_count) OVER (), 0),
            4
        ) AS z_score
    FROM (
        SELECT "date",
               COUNT(*) AS incident_count
        FROM AUSTIN.AUSTIN_INCIDENTS.INCIDENTS_2016
        WHERE "descript" = 'PUBLIC INTOXICATION'
          AND "date" BETWEEN '2016-01-01' AND '2016-12-31'
        GROUP BY "date"
    ) AS daily_counts
) AS stats
ORDER BY z_score DESC NULLS LAST
LIMIT 1 OFFSET 1;