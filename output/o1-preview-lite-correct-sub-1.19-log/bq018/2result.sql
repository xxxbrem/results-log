SELECT
  FORMAT_DATE('%m-%d', date) AS Date
FROM (
  SELECT
    date,
    cumulative_confirmed,
    LAG(cumulative_confirmed) OVER (ORDER BY date) AS previous_cumulative_confirmed,
    SAFE_DIVIDE(cumulative_confirmed - LAG(cumulative_confirmed) OVER (ORDER BY date), LAG(cumulative_confirmed) OVER (ORDER BY date)) AS growth_rate
  FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name = 'United States of America'
    AND date BETWEEN '2020-03-01' AND '2020-04-30'
    AND aggregation_level = 0
    AND cumulative_confirmed IS NOT NULL
)
WHERE
  growth_rate IS NOT NULL AND previous_cumulative_confirmed > 0
ORDER BY
  growth_rate DESC
LIMIT 1;