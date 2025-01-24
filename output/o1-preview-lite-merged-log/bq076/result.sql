SELECT
  LPAD(CAST(EXTRACT(MONTH FROM DATETIME(`date`, 'America/Chicago')) AS STRING), 2, '0') AS `Month_num`,
  FORMAT_DATETIME('%B', DATETIME(`date`, 'America/Chicago')) AS `Month`
FROM
  `bigquery-public-data.chicago_crime.crime`
WHERE
  EXTRACT(YEAR FROM DATETIME(`date`, 'America/Chicago')) = 2016
  AND `primary_type` = 'MOTOR VEHICLE THEFT'
GROUP BY
  `Month_num`, `Month`
ORDER BY
  COUNT(*) DESC
LIMIT 1;