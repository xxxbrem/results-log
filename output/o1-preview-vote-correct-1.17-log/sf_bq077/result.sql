SELECT "year", MAX(monthly_total) AS highest_monthly_motor_thefts
FROM (
    SELECT EXTRACT(year FROM parsed_date) AS "year", EXTRACT(month FROM parsed_date) AS "month", COUNT(*) AS monthly_total
    FROM (
        SELECT
            CASE 
                WHEN "date" >= 1e15 THEN TO_TIMESTAMP_NTZ("date" / 1000000)
                WHEN "date" >= 1e12 THEN TO_TIMESTAMP_NTZ("date" / 1000)
                ELSE TO_TIMESTAMP_NTZ("date")
            END AS parsed_date
        FROM "CHICAGO"."CHICAGO_CRIME"."CRIME"
        WHERE "primary_type" = 'MOTOR VEHICLE THEFT'
    ) AS sub1
    WHERE EXTRACT(year FROM parsed_date) BETWEEN 2010 AND 2016
    GROUP BY EXTRACT(year FROM parsed_date), EXTRACT(month FROM parsed_date)
) AS sub2
GROUP BY "year"
ORDER BY "year";