SELECT
  wy.`name` AS Name,
  ROUND(wy.total_number / usa.total_number, 4) AS Proportion
FROM (
  SELECT `name`, SUM(`number`) AS total_number
  FROM `bigquery-public-data.usa_names.usa_1910_current`
  WHERE `state` = 'WY' AND `gender` = 'F' AND `year` = 2021
  GROUP BY `name`
) AS wy
JOIN (
  SELECT `name`, SUM(`number`) AS total_number
  FROM `bigquery-public-data.usa_names.usa_1910_current`
  WHERE `gender` = 'F' AND `year` = 2021
  GROUP BY `name`
) AS usa
ON wy.`name` = usa.`name`
ORDER BY wy.total_number / usa.total_number DESC
LIMIT 1;