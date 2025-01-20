SELECT
  EXTRACT(MONTH FROM `date` AT TIME ZONE 'America/Chicago') AS Month_num,
  FORMAT_TIMESTAMP('%B', `date`, 'America/Chicago') AS Month
FROM
  `bigquery-public-data.chicago_crime.crime`
WHERE
  `primary_type` = 'MOTOR VEHICLE THEFT'
  AND `year` = 2016
GROUP BY
  Month_num,
  Month
ORDER BY
  COUNT(*) DESC
LIMIT 1;