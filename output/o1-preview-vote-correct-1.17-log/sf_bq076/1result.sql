SELECT
    EXTRACT(MONTH FROM
        CASE
            WHEN "date" >= 1e15 THEN TO_TIMESTAMP_NTZ("date" / 1000000)
            WHEN "date" >= 1e12 THEN TO_TIMESTAMP_NTZ("date" / 1000)
            ELSE TO_TIMESTAMP_NTZ("date")
        END
    ) AS "month_num",
    TO_CHAR(
        CASE
            WHEN "date" >= 1e15 THEN TO_TIMESTAMP_NTZ("date" / 1000000)
            WHEN "date" >= 1e12 THEN TO_TIMESTAMP_NTZ("date" / 1000)
            ELSE TO_TIMESTAMP_NTZ("date")
        END,
        'Month'
    ) AS "month_name",
    COUNT(*) AS "number_of_motor_vehicle_thefts"
FROM "CHICAGO"."CHICAGO_CRIME"."CRIME"
WHERE "primary_type" = 'MOTOR VEHICLE THEFT' AND "year" = 2016
GROUP BY 1, 2
ORDER BY "number_of_motor_vehicle_thefts" DESC NULLS LAST;