SELECT
    t."year",
    t."month_num",
    t."month_name",
    t."highest_monthly_motor_thefts"
FROM (
    SELECT
        EXTRACT(YEAR FROM TO_TIMESTAMP_NTZ("date" / 1e6)) AS "year",
        EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ("date" / 1e6)) AS "month_num",
        TO_CHAR(TO_TIMESTAMP_NTZ("date" / 1e6), 'Mon') AS "month_name",
        COUNT(*) AS "highest_monthly_motor_thefts",
        ROW_NUMBER() OVER (
            PARTITION BY EXTRACT(YEAR FROM TO_TIMESTAMP_NTZ("date" / 1e6))
            ORDER BY COUNT(*) DESC NULLS LAST
        ) AS "rn"
    FROM CHICAGO.CHICAGO_CRIME.CRIME
    WHERE "primary_type" = 'MOTOR VEHICLE THEFT'
      AND "date" IS NOT NULL
    GROUP BY
        EXTRACT(YEAR FROM TO_TIMESTAMP_NTZ("date" / 1e6)),
        EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ("date" / 1e6)),
        TO_CHAR(TO_TIMESTAMP_NTZ("date" / 1e6), 'Mon')
) t
WHERE t."year" BETWEEN 2010 AND 2016
  AND t."rn" = 1
ORDER BY t."year" ASC NULLS LAST;