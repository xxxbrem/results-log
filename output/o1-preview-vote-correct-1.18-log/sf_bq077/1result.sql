SELECT
    "year",
    MAX("cnt") AS "HighestMonthlyMotorThefts"
FROM (
    SELECT
        "year",
        MONTH(TO_TIMESTAMP_NTZ("date" / 1000000)) AS "month",
        COUNT(*) AS "cnt"
    FROM CHICAGO.CHICAGO_CRIME.CRIME
    WHERE "primary_type" = 'MOTOR VEHICLE THEFT' AND "year" BETWEEN 2010 AND 2016
    GROUP BY "year", "month"
) AS sub
GROUP BY "year"
ORDER BY "year";