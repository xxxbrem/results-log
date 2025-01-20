SELECT 
  wyoming_names.name AS Name, 
  ROUND(wyoming_names.wyoming_count / all_states_names.total_count, 4) AS Proportion
FROM
  (
    SELECT name, number AS wyoming_count
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE state = 'WY' AND gender = 'F' AND year = 2021
  ) AS wyoming_names
JOIN
  (
    SELECT name, SUM(number) AS total_count
    FROM `bigquery-public-data.usa_names.usa_1910_current`
    WHERE gender = 'F' AND year = 2021
    GROUP BY name
  ) AS all_states_names
ON wyoming_names.name = all_states_names.name
ORDER BY Proportion DESC, Name ASC
LIMIT 1;