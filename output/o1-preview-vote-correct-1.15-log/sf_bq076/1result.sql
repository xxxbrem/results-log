SELECT
    EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ("date" / 1000000)) AS "Month_num",
    TRIM(TO_CHAR(TO_TIMESTAMP_NTZ("date" / 1000000), 'Month')) AS "Month",
    COUNT(*) AS "Number_of_Motor_Vehicle_Thefts"
FROM
    CHICAGO.CHICAGO_CRIME.CRIME
WHERE
    "primary_type" = 'MOTOR VEHICLE THEFT' AND
    "year" = 2016
GROUP BY
    1, 2
ORDER BY
    "Number_of_Motor_Vehicle_Thefts" DESC NULLS LAST;