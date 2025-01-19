WITH monthly_counts AS (
    SELECT
        "year",
        EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ("date" / 1e6)) AS "month",
        COUNT(*) AS "thefts"
    FROM CHICAGO.CHICAGO_CRIME.CRIME
    WHERE
        "primary_type" = 'MOTOR VEHICLE THEFT'
        AND "year" BETWEEN 2010 AND 2016
    GROUP BY
        "year", "month"
)
SELECT
    "year",
    MAX("thefts") AS "Highest_Monthly_Motor_Thefts"
FROM monthly_counts
GROUP BY "year"
ORDER BY "year";