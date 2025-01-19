SELECT
    EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ("date" / 1e6)) AS "Month_num",
    TO_CHAR(TO_TIMESTAMP_NTZ("date" / 1e6), 'Month') AS "Month",
    COUNT(*) AS "Number_of_Motor_Vehicle_Thefts"
FROM
    "CHICAGO"."CHICAGO_CRIME"."CRIME"
WHERE
    "primary_type" = 'MOTOR VEHICLE THEFT'
    AND "year" = 2016
GROUP BY
    "Month_num",
    "Month"
ORDER BY
    "Number_of_Motor_Vehicle_Thefts" DESC NULLS LAST
LIMIT 1;