SELECT
  FORMAT('%02d', EXTRACT(MONTH FROM `date`)) AS Month_num,
  FORMAT_DATE('%B', DATE(`date`)) AS Month
FROM `bigquery-public-data.chicago_crime.crime`
WHERE `primary_type` = 'MOTOR VEHICLE THEFT' AND `year` = 2016
GROUP BY Month_num, Month
ORDER BY COUNT(*) DESC
LIMIT 1;