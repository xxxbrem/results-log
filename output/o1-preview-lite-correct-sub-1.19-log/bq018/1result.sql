SELECT
  FORMAT_DATE('%m-%d', `date`) AS Date
FROM (
  SELECT
    `date`,
    SAFE_DIVIDE(`new_confirmed`, LAG(`cumulative_confirmed`) OVER (ORDER BY `date`)) AS growth_rate
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    `location_key` = 'US' AND `date` BETWEEN '2020-03-01' AND '2020-04-30'
)
ORDER BY
  growth_rate DESC,
  `date` ASC
LIMIT 1;