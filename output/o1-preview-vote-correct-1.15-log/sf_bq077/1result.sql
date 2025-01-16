SELECT
  "year",
  MAX(monthly_count) AS "highest_motor_thefts_in_month"
FROM (
  SELECT
    "year",
    EXTRACT(MONTH FROM "timestamp_column") AS "month",
    COUNT(*) AS monthly_count
  FROM (
    SELECT
      "primary_type",
      "year",
      CASE
        WHEN "date" >= 1e15 THEN TO_TIMESTAMP_NTZ("date" / 1000000)
        WHEN "date" >= 1e12 THEN TO_TIMESTAMP_NTZ("date" / 1000)
        ELSE TO_TIMESTAMP_NTZ("date")
      END AS "timestamp_column"
    FROM
      CHICAGO.CHICAGO_CRIME.CRIME
    WHERE
      "primary_type" = 'MOTOR VEHICLE THEFT' AND
      "year" BETWEEN 2010 AND 2016
  ) AS sub
  GROUP BY
    "year", EXTRACT(MONTH FROM "timestamp_column")
) AS monthly_counts
GROUP BY
  "year"
ORDER BY
  "year";