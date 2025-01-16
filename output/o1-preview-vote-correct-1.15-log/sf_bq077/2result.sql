SELECT "year", MAX("monthly_count") AS "Highest_monthly_motor_thefts"
FROM (
  SELECT "year",
         EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ("date" / 1e6)) AS "month",
         COUNT(*) AS "monthly_count"
  FROM "CHICAGO"."CHICAGO_CRIME"."CRIME"
  WHERE "primary_type" = 'MOTOR VEHICLE THEFT' AND "year" BETWEEN 2010 AND 2016
  GROUP BY "year", "month"
) AS monthly_thefts
GROUP BY "year"
ORDER BY "year";