SELECT
  year,
  MAX(motor_theft_count) AS Highest_Motor_Thefts_in_One_Month
FROM (
  SELECT
    year,
    EXTRACT(MONTH FROM `date`) AS month,
    COUNT(unique_key) AS motor_theft_count
  FROM
    `bigquery-public-data.chicago_crime.crime`
  WHERE
    primary_type = 'MOTOR VEHICLE THEFT' AND year BETWEEN 2010 AND 2016
  GROUP BY
    year, month
)
GROUP BY
  year
ORDER BY
  year;