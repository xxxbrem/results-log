SELECT
  "year",
  MAX(thefts_in_month) AS "Highest_Monthly_Motor_Thefts"
FROM (
  SELECT
    "year",
    COUNT(*) AS thefts_in_month
  FROM
    CHICAGO.CHICAGO_CRIME.CRIME
  WHERE
    "primary_type" = 'MOTOR VEHICLE THEFT'
    AND "year" BETWEEN 2010 AND 2016
  GROUP BY
    "year",
    DATE_TRUNC('month', TO_TIMESTAMP("date" / 1000000))
) AS monthly_counts
GROUP BY
  "year"
ORDER BY
  "year";