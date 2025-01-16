SELECT 
    TO_CHAR(
        CASE 
            WHEN "date" >= 1e15 THEN TO_TIMESTAMP_NTZ("date" / 1e6)
            WHEN "date" >= 1e12 THEN TO_TIMESTAMP_NTZ("date" / 1e3)
            ELSE TO_TIMESTAMP_NTZ("date")
        END, 'Month') AS "Month",
    DATE_PART('month',
        CASE 
            WHEN "date" >= 1e15 THEN TO_TIMESTAMP_NTZ("date" / 1e6)
            WHEN "date" >= 1e12 THEN TO_TIMESTAMP_NTZ("date" / 1e3)
            ELSE TO_TIMESTAMP_NTZ("date")
        END) AS "Month_num",
    COUNT(*) AS "Number_of_Motor_Vehicle_Thefts"
FROM CHICAGO.CHICAGO_CRIME.CRIME
WHERE "primary_type" = 'MOTOR VEHICLE THEFT' AND "year" = 2016
GROUP BY 1, 2
ORDER BY "Number_of_Motor_Vehicle_Thefts" DESC NULLS LAST
LIMIT 1;