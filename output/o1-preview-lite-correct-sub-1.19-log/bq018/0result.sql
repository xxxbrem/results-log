WITH us_daily AS (
  SELECT
    date,
    MAX(cumulative_confirmed) AS cumulative_confirmed
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_code = 'US' AND DATE BETWEEN '2020-03-01' AND '2020-04-30'
  GROUP BY
    date
),
us_growth AS (
  SELECT
    date,
    cumulative_confirmed,
    LAG(cumulative_confirmed) OVER (ORDER BY date) AS previous_cumulative_confirmed,
    SAFE_DIVIDE(cumulative_confirmed - LAG(cumulative_confirmed) OVER (ORDER BY date), LAG(cumulative_confirmed) OVER (ORDER BY date)) AS growth_rate
  FROM
    us_daily
)
SELECT
  FORMAT_DATE('%m-%d', date) AS Date
FROM
  us_growth
WHERE
  previous_cumulative_confirmed > 0
ORDER BY
  growth_rate DESC
LIMIT 1;