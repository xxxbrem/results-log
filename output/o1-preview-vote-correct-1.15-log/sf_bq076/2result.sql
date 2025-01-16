SELECT
    MONTHNAME(
        TO_TIMESTAMP_NTZ(
            CASE
                WHEN "date" >= 1e15 THEN "date" / 1000000
                WHEN "date" >= 1e12 THEN "date" / 1000
                ELSE "date"
            END
        )
    ) AS "Month",
    MONTH(
        TO_TIMESTAMP_NTZ(
            CASE
                WHEN "date" >= 1e15 THEN "date" / 1000000
                WHEN "date" >= 1e12 THEN "date" / 1000
                ELSE "date"
            END
        )
    ) AS "Month_num",
    COUNT(*) AS "Total_Motor_Vehicle_Thefts"
FROM
    CHICAGO.CHICAGO_CRIME.CRIME
WHERE
    "primary_type" = 'MOTOR VEHICLE THEFT'
    AND "year" = 2016
GROUP BY
    "Month",
    "Month_num"
ORDER BY
    "Total_Motor_Vehicle_Thefts" DESC NULLS LAST
LIMIT 1;