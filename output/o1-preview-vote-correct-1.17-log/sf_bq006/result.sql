WITH daily_counts AS (
    SELECT 
        "date", 
        COUNT(*) AS "incident_count"
    FROM 
        AUSTIN.AUSTIN_INCIDENTS.INCIDENTS_2016
    WHERE 
        "date" BETWEEN '2016-01-01' AND '2016-12-31'
        AND "descript" = 'PUBLIC INTOXICATION'
    GROUP BY 
        "date"
),
stats AS (
    SELECT 
        AVG("incident_count") AS "mean_incidents",
        STDDEV("incident_count") AS "stddev_incidents"
    FROM 
        daily_counts
),
z_scores AS (
    SELECT 
        dc."date",
        dc."incident_count",
        ROUND( (dc."incident_count" - s."mean_incidents") / s."stddev_incidents", 4 ) AS "z_score"
    FROM 
        daily_counts dc, stats s
)
SELECT 
    "date"
FROM 
    z_scores
ORDER BY 
    "z_score" DESC NULLS LAST
LIMIT 1 OFFSET 1;