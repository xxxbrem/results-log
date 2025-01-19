SELECT
  FORMAT_DATE('%m-%d', `date`) AS Date
FROM (
  SELECT
    `date`,
    SAFE_DIVIDE(`new_confirmed`, (`cumulative_confirmed` - `new_confirmed`)) AS growth_rate
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    `country_name` = 'United States of America'
    AND `date` BETWEEN '2020-03-01' AND '2020-04-30'
    AND (`cumulative_confirmed` - `new_confirmed`) > 0
  )
ORDER BY
  growth_rate DESC, `date` ASC
LIMIT
 1;